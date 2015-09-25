class ConversationSerializer < ActiveModel::Serializer
  attributes :id,
    :saved,
    :user

  def user
    EmployeeSerializer.new object.other(scope)
  end

  def saved
    object.saved?
  end
end