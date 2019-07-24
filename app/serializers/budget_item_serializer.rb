class BudgetItemSerializer < ApplicationRecordSerializer
  attributes :budget, :title_with_amount, :available_amount

  def serialize_all_fields
    true
  end
end
