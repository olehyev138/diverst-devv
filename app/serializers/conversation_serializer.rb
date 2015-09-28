class ConversationSerializer < ActiveModel::Serializer
  attributes :id,
    :saved,
    :expires_soon,
    :user

  def user
    EmployeeSerializer.new object.other(scope)
  end

  def saved
    object.saved?
  end

  def expires_soon
    object.expires_soon?
  end
end