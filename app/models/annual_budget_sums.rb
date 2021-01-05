class AnnualBudgetSums < ApplicationRecord
  self.table_name = 'annual_budgets_sums'
  include MaterializedTable

  belongs_to :annual_budget

  def readonly?
    true
  end
end
