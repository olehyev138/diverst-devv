class InitiativeUserSerializer < ApplicationRecordSerializer
  attributes :user, :initiative

  belongs_to :user
  belongs_to :initiative

  def serialize_all_fields
    true
  end
end
