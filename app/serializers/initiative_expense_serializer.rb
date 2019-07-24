class InitiativeExpenseSerializer < ApplicationRecordSerializer
  attributes :owner, :initiative

  def serialize_all_fields
    true
  end
end
