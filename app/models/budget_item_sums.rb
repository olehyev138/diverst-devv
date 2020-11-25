class BudgetItemSums < ApplicationRecord
  self.table_name = 'budget_items_sums'
  include MaterializedTable

  belongs_to :budget_item

  def readonly?
    true
  end
end
