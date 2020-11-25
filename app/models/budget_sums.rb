class BudgetSums < ApplicationRecord
  self.table_name = 'budgets_sums'
  include MaterializedTable

  belongs_to :budget

  def readonly?
    true
  end
end
