class BudgetSerializer < ApplicationRecordSerializer
  attributes :approver, :requester, :group

  def serialize_all_fields
    true
  end
end
