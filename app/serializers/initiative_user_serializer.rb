class InitiativeUserSerializer < ApplicationRecordSerializer
  attributes :user, :initiative

  def user
    UserSerializer.new(object.user).attributes
  end

  def initiative
    InitiativeSerializer.new(object.initiative).attributes
  end

  def serialize_all_fields
    true
  end
end
