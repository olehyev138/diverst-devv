class BudgetItem < ApplicationRecord
  include BudgetItem::Actions
  LEFTOVER_BUDGET_ITEM_ID = -1

  belongs_to :budget, counter_cache: true
  has_one :annual_budget, through: :budget
  has_one :group, through: :budget
  has_one :parent_group, through: :annual_budget, source: :budget_head, source_type: Group
  has_one :region, through: :annual_budget, source: :budget_head, source_type: Region
  has_one :budget_item_sums, class_name: 'BudgetItemSums'

  has_many :initiatives, dependent: :nullify
  has_many :budget_users, dependent: :destroy
  has_many :initiatives_expenses, through: :budget_users, source: :expenses

  validates_length_of :title, maximum: 191
  validates_presence_of :budget
  validates :title, presence: true, length: { minimum: 2 }
  validates :estimated_amount, numericality: { less_than_or_equal_to: 999999, message: I18n.t('errors.budget.maximum') }

  scope :available, -> { joins(:budget).where(is_done: false).where('budgets.is_approved = TRUE') }
  scope :allocated, -> { where(is_done: true) }
  scope :approved, -> { joins(:budget).where(budgets: { is_approved: true }) }
  scope :not_approved, -> { joins(:budget).where(budgets: { is_approved: false }) }
  scope :pending, -> { joins(:budget).where(budgets: { is_approved: nil }) }
  scope :private_scope, -> (user_id = nil) { joins(:budget).where('is_private = FALSE OR budgets.requester_id = ?', user_id) }
  scope :current, -> { joins(:annual_budget).where(annual_budgets: { closed: false }) }
  scope :with_expenses, -> do
    select(
        '`budget_items`.*',
        'COALESCE(`spent`, 0) as spent',
        'COALESCE(`reserved`, 0) as reserved',
        'COALESCE(`user_estimates`, 0) as user_estimates',
        'COALESCE(`finalized_expenditures`, 0) as finalized_expenditures',
        'COALESCE(`estimated_amount` - `spent`, 0) as unspent',
        'IF((`budget_id` IS NULL OR `is_done` OR NOT `budgets`.`is_approved`) = TRUE, 0, COALESCE(`estimated_amount`, 0) - COALESCE(`reserved`, 0)) as available'
      ).joins(:budget).left_joins(:budget_item_sums)
  end

  delegate :finalized, to: :initiatives, prefix: true
  delegate :finalized, to: :initiatives_expenses, prefix: 'expenses'
  delegate :active, to: :initiatives, prefix: true
  delegate :active, to: :initiatives_expenses, prefix: 'expenses'

  BUDGET_KEYS = ['budget_id', 'annual_budget_id']

  def self.get_foreign_keys(old_or_new = 'NEW')
    <<~SQL.gsub(/\s+/, ' ').strip
    #{BUDGET_KEYS.map { |col| "SET @#{col} = -1;" }.join(' ')}
    #{BudgetItem.joins(:annual_budget).select(
      '`budgets`.`id`',
      '`budgets`.`annual_budget_id`'
    ).where(
      "`budget_items`.`id` = #{old_or_new}.`id`"
    ).to_sql}
    INTO #{BUDGET_KEYS.map { |col| "@#{col}" }.join(", ")};
    SQL
  end

  trigger.after(:insert) do
    <<~SQL.gsub(/\s+/, ' ').strip
    #{get_foreign_keys}
    #{BudgetSums.budget_inserted}
    #{AnnualBudgetSums.budget_inserted}
    SQL
  end

  trigger.before(:delete) do
    <<~SQL.gsub(/\s+/, ' ').strip
    #{get_foreign_keys('OLD')}
    #{BudgetSums.budget_deleted}
    #{AnnualBudgetSums.budget_deleted}
    SQL
  end

  def close!
    if is_done?
      errors.add(:base, I18n.t('errors.budget.closed'))
      return false
    end

    if initiatives.active.any?
      errors.add(:base, I18n.t('errors.budget.used'))
      return false
    end

    self.update(is_done: true)
  end

  def available_for_event(event)
    budget_users = BudgetUser.find_by(budgetable: event, budget_item_id: id)
    event_offset = budget_users.present? ? budget_users.estimated : 0
    available + event_offset
  end

  def title_with_amount(event = nil)
    "#{title} ($%.2f)" % available_for_event(event)
  end

  [:spent, :reserved, :user_estimates, :finalized_expenditures].each do |method|
    define_method method do
      if attributes.include? method.to_s
        self[method.to_s]
      else
        budget_item_sums&.send(method) || 0
      end
    end
  end

  def unspent
    estimated_amount - spent
  end

  def available
    return 0 if budget.blank? || is_done || !(budget.is_approved?)

    estimated_amount - reserved
  end

  def reload!
    @expenses = 0
    @available = 0
    @unspent = 0
    @finalized_expenditure = 0
    super
  end

  def approve!
    self.update(deprecated_available_amount: estimated_amount)
  end
end
