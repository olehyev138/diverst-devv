class InitiativeExpenseSerializer < ApplicationRecordSerializer
  attributes :owner, :budget_user

  def serialize_all_fields
    true
  end
end
