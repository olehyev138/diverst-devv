class BudgetSums < ApplicationRecord
  self.primary_key = 'budget_id'
  self.table_name = 'budgets_sums'
  belongs_to :budget

  def readonly?
    true
  end
end
