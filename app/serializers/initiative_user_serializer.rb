class InitiativeUserSerializer < ApplicationRecordSerializer
  attributes :user, :initiative

  def serialize_all_fields
    true
  end
end
