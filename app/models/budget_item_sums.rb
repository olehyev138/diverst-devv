class BudgetItemSums < ApplicationRecord
  self.primary_key = 'budget_item_id'
  self.table_name = 'budget_items_sums'
  belongs_to :budget_item

  def readonly?
    true
  end
end
