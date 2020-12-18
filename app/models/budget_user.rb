class BudgetUser < ApplicationRecord
  include BudgetUser::Actions

  attr_accessor :skip_allocate_budget_funds

  belongs_to :budgetable, polymorphic: true
  belongs_to :budget_item, -> { with_expenses }
  has_one :budget, through: :budget_item
  has_one :group, through: :budget
  has_one :annual_budget, through: :budget
  has_one :enterprise, through: :group
  has_one :parent_group, through: :annual_budget, source: :budget_head, source_type: Group
  has_one :region, through: :annual_budget, source: :budget_head, source_type: Region
  has_many :expenses, dependent: :destroy, class_name: 'InitiativeExpense'
  has_one :budget_user_sums, class_name: 'BudgetUserSums'

  # validate -> { allocate_budget_funds unless check_if_available }

  validates :budget_item_id,
            presence: true,
            uniqueness: { scope: [:budgetable_type, :budgetable_id] }

  scope :finalized, -> { where(finished_expenses: true) }
  scope :active, -> { where(finished_expenses: false) }

  scope :with_expenses, -> do
    select(
        '`budget_users`.*',
        'COALESCE(`spent`, 0)                                                           as spent',
        '`estimated`                                                                    as user_estimate',
        'IF(`finished_expenses` = TRUE, COALESCE(`spent`, 0), COALESCE(`estimated`, 0)) as reserved',
        'IF(`finished_expenses` = TRUE, COALESCE(`spent`, 0), 0)                        as final_expense'
      ).left_joins(:budget_user_sums)
  end

  def group
    budgetable&.group
  end

  def user_path
    budgetable.path
  end

  def finish_expenses!
    if finished_expenses?
      errors.add(:initiative, 'Expenses are already finished')
      return false
    end

    self.update(finished_expenses: true)
  end

  def check_if_available
    if budget_item.present? && estimated > budget_item.available
      errors.add(:budget_item_id, 'sorry, this budget doesn\'t have the sufficient funds')
      return false
    end
    true
  end

  def budget_item_is_approved
    errors.add(:budget_item, 'Budget Item is not approved') unless budget_item.blank? || budget.is_approved?
  end

  polymorphic_alias :budgetable, Initiative

  BUDGET_KEYS = ['budget_item_id', 'budget_id', 'annual_budget_id']

  def self.get_foreign_keys(old_or_new = 'NEW')
    <<~SQL.gsub(/\s+/, ' ').strip
    #{BUDGET_KEYS.map { |col| "SET @#{col} = -1;" }.join(' ')}
    #{BudgetItem.joins(:budget).select(
        '`budget_items`.`id`',
        '`budget_items`.`budget_id`',
        '`budgets`.`annual_budget_id`'
      ).where(
        "`budget_items`.`id` = #{old_or_new}.`budget_item_id`"
      ).to_sql}
    INTO #{BUDGET_KEYS.map { |col| "@#{col}" }.join(", ")};
    SQL
  end

  trigger.after(:insert) do
    <<~SQL.gsub(/\s+/, ' ').strip
    #{get_foreign_keys}
    #{BudgetItemSums.budget_user_inserted}
    #{BudgetSums.budget_user_inserted}
    #{AnnualBudgetSums.budget_user_inserted}
    SQL
  end

  trigger.before(:delete) do
    <<~SQL.gsub(/\s+/, ' ').strip
    #{get_foreign_keys('OLD')}
    #{BudgetItemSums.budget_user_deleted}
    #{BudgetSums.budget_user_deleted}
    #{AnnualBudgetSums.budget_user_deleted}
    SQL
  end

  trigger.after(:update).of(:estimated) do
    <<~SQL.gsub(/\s+/, ' ').strip
    #{get_foreign_keys}
    #{BudgetItemSums.budget_user_estimate_updated}
    #{BudgetSums.budget_user_estimate_updated}
    #{AnnualBudgetSums.budget_user_estimate_updated}
    SQL
  end

  trigger.after(:update).of(:finished_expenses) do
    <<~SQL.gsub(/\s+/, ' ').strip
    #{get_foreign_keys}
    #{BudgetItemSums.budget_user_finalized}
    #{BudgetSums.budget_user_finalized}
    #{AnnualBudgetSums.budget_user_finalized}
    SQL
  end
end
