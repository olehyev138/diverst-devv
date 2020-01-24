class BudgetSerializer < ApplicationRecordSerializer
  attributes :approver, :requested_amount, :available_amount

  def serialize_all_fields
    true
  end
end
