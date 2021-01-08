class Budget < ApplicationRecord
  include PublicActivity::Common
  include Budget::Actions

  belongs_to :annual_budget, -> { with_expenses }
  belongs_to :group
  belongs_to :approver, class_name: 'User', foreign_key: 'approver_id'
  belongs_to :requester, class_name: 'User', foreign_key: 'requester_id'
  has_one :parent_group, through: :annual_budget, source: :budget_head, source_type: Group
  has_one :region, through: :annual_budget, source: :budget_head, source_type: Region
  has_one :budget_sums, class_name: 'BudgetSums'

  has_many :checklists, dependent: :destroy
  has_many :budget_items, -> { with_expenses }, dependent: :destroy, inverse_of: :budget
  accepts_nested_attributes_for :budget_items, reject_if: :all_blank, allow_destroy: true

  scope :approved, -> { where(is_approved: true) }
  scope :not_approved, -> { where(is_approved: false) }
  scope :pending, -> { where(is_approved: nil) }
  scope :with_expenses, -> do
    select(
        '`budgets`.*',
        'COALESCE(`spent`, 0) as spent',
        'COALESCE(`reserved`, 0) as reserved',
        'COALESCE(`requested_amount`, 0) as requested_amount',
        'COALESCE(`user_estimates`, 0) as user_estimates',
        'COALESCE(`finalized_expenditures`, 0) as finalized_expenditures',
        'COALESCE(IF(`is_approved` = TRUE, `requested_amount`, 0) - `reserved`, 0) as available',
        'COALESCE(COALESCE(`requested_amount`, 0) - `spent`, 0) as unspent',
        'IF(`is_approved` = TRUE, `requested_amount`, 0) as approved_amount'
      ).left_joins(:budget_sums, :annual_budget)
  end

  # scope :with_available_funds, -> { where('available_amount > 0')}

  after_save :send_email_notification

  validates_length_of :decline_reason, maximum: 191
  validates_length_of :comments, maximum: 65535
  validates_length_of :description, maximum: 65535


  delegate :currency, to: :annual_budget

  def group_id
    group&.id
  end

  [:spent, :reserved, :requested_amount, :user_estimates, :finalized_expenditures].each do |method|
    define_method method do
      if attributes.include? method.to_s
        self[method.to_s]
      else
        budget_sums&.send(method) || 0
      end
    end
  end

  def available
    return 0 unless is_approved

    requested_amount - reserved
  end

  def unspent
    requested_amount - spent
  end

  def approved_amount
    return 0 unless is_approved

    requested_amount
  end

  def reload
    @requested_amount = nil
    @available = nil
    super
  end

  def status_title
    return 'Pending' if is_approved.nil?

    if is_approved
      'Approved'
    else
      'Declined'
    end
  end

  def item_count
    budget_items.size
  end

  def requested_at
    created_at
  end

  def self.pre_approved_events(group, user = nil)
    related_budgets = self.joins(:group)
                          .where(annual_budgets: { group: group })
                          .approved
                          .includes(:budget_items)

    budget_items = related_budgets.map { |b| b.budget_items }

    flattened_items = budget_items.flatten.select { |bi| bi.is_done == false }

    if user.present?
      flattened_items = flattened_items.select do |bi|
        if bi.is_private?
          bi.budget.requester == user
        else
          true
        end
      end
    end

    flattened_items
  end

  def annual_budget_set?
    unless (annual_budget&.amount || 0) > 0
      I18n.t('errors.budget.budget_set')
    end
  end

  def annual_budget_open?
    unless annual_budget.present? && !annual_budget.closed
      I18n.t('errors.budget.annual_budget_closed')
    end
  end

  def request_surplus?
    unless requested_amount.present? && requested_amount <= annual_budget&.free
      I18n.t('errors.budget.surplus')
    end
  end

  private

  def send_email_notification
    send_approval_request if is_approved.nil?
  end

  def send_approval_request
    return if approver.blank?

    BudgetMailer.approve_request(self, approver).deliver_later
  end

  def send_approval_notification
    BudgetMailer.budget_approved(self).deliver_later if self.requester
  end

  def send_denial_notification
    BudgetMailer.budget_declined(self).deliver_later if self.requester
  end

  BUDGET_KEYS = ['budget_id', 'annual_budget_id']

  def self.get_foreign_keys(old_or_new = 'NEW')
    <<~SQL.gsub(/\s+/, ' ').strip
    #{BUDGET_KEYS.map { |col| "SET @#{col} = -1;" }.join(' ')}
    #{Budget.select(
        '`budgets`.`id`',
        '`budgets`.`annual_budget_id`'
      ).where(
        "`budgets`.`id` = #{old_or_new}.`id`"
      ).to_sql}
    INTO #{BUDGET_KEYS.map { |col| "@#{col}" }.join(", ")};
    SQL
  end

  trigger.after(:update).of(:is_approved) do
    <<~SQL.gsub(/\s+/, ' ').strip
    #{get_foreign_keys}
    #{AnnualBudgetSums.budget_approved}
    SQL
  end
end
