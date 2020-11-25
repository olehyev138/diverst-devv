class AnnualBudgetSums < ApplicationRecord
  self.primary_key = 'annual_budget_id'
  self.table_name = 'annual_budgets_sums'
  belongs_to :annual_budget

  def readonly?
    true
  end
end
