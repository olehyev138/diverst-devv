class BudgetUser < ApplicationRecord
  belongs_to :budgetable, polymorphic: true
  belongs_to :budget_item
  has_one :budget, through: :budget_item
  has_one :annual_budget, through: :budget
  has_many :expenses, dependent: :destroy, class_name: 'InitiativeExpense'

  def group
    budgetable&.group
  end

  polymorphic_alias :budgetable, Initiative

  BUDGET_KEYS = ['budget_item_id', 'budget_id', 'annual_budget_id']

  def self.get_foreign_keys(old_or_new = 'NEW')
    <<~SQL.gsub(/\s+/, ' ').strip
    #{BUDGET_KEYS.map {|col| "SET @#{col} = -1;" }.join(' ')}
    #{BudgetItem.joins(:budget).select(
        '`budget_items`.`id`',
        '`budget_items`.`budget_id`',
        '`budgets`.`annual_budget_id`'
    ).where(
        "`budget_users`.`id` = #{old_or_new}.`budget_item_id`"
    ).to_sql}
    INTO #{BUDGET_KEYS.map {|col| "@#{col}" }.join(", ")};
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
