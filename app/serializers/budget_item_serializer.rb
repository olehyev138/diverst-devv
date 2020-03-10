class BudgetItemSerializer < ApplicationRecordSerializer
  attributes :title_with_amount, :available_amount

  def serialize_all_fields
    true
  end
end
