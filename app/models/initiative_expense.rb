class InitiativeExpense < ApplicationRecord
  # belongs_to :initiative
  belongs_to :owner, class_name: 'User'
  # belongs_to :budget_item
  belongs_to :budget_user, -> { with_expenses }
  has_one :budget_item, through: :budget_user
  has_one :budget, through: :budget_item
  has_one :group, through: :budget
  has_one :annual_budget, through: :budget
  has_one :enterprise, through: :annual_budget

  validates_length_of :description, maximum: 191
  validates :budget_user, presence: true
  # validates :annual_budget, presence: true
  validates :owner, presence: true
  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validate -> { initiative_is_not_finalized }

  scope :finalized, -> { joins(:budget_user).where(budget_users: { finished_expenses: true }) }
  scope :active, -> { joins(:budget_user).where(budget_users: { finished_expenses: false }) }

  def initiative_is_not_finalized
    if budget_user.blank? || budget_user.finished_expenses?
      errors.add(:budget_user, "Can't #{new_record? ? 'add' : 'edit'} an expense for a closed initiative")
    end
  end

  BUDGET_KEYS = ['budget_user_id', 'budget_item_id', 'budget_id', 'annual_budget_id']

  def self.get_foreign_keys(old_or_new = 'NEW')
    <<~SQL.gsub(/\s+/, ' ').strip
    #{BUDGET_KEYS.map { |col| "SET @#{col} = -1;" }.join(' ')}
    #{BudgetUser.joins(:budget).select(
        '`budget_users`.`id`',
        '`budget_users`.`budget_item_id`',
        '`budget_items`.`budget_id`',
        '`budgets`.`annual_budget_id`'
      ).where(
        "`budget_users`.`id` = #{old_or_new}.`budget_user_id`"
      ).to_sql}
    INTO #{BUDGET_KEYS.map { |col| "@#{col}" }.join(", ")};
    SQL
  end

  trigger.after(:insert) do
    <<~SQL.gsub(/\s+/, ' ').strip
    #{get_foreign_keys}
    #{BudgetUserSums.expense_inserted}
    #{BudgetItemSums.expense_inserted}
    #{BudgetSums.expense_inserted}
    #{AnnualBudgetSums.expense_inserted}
    SQL
  end

  trigger.after(:delete) do
    <<~SQL.gsub(/\s+/, ' ').strip
    #{get_foreign_keys('OLD')}
    #{BudgetUserSums.expense_deleted}
    #{BudgetItemSums.expense_deleted}
    #{BudgetSums.expense_deleted}
    #{AnnualBudgetSums.expense_deleted}
    SQL
  end

  trigger.after(:update).of(:amount) do
    <<~SQL.gsub(/\s+/, ' ').strip
    #{get_foreign_keys}
    #{BudgetUserSums.expense_updated}
    #{BudgetItemSums.expense_updated}
    #{BudgetSums.expense_updated}
    #{AnnualBudgetSums.expense_updated}
    SQL
  end
end
