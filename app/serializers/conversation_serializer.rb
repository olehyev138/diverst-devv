class ConversationSerializer < ActiveModel::Serializer
  attributes :id,
    :user

  def user
    EmployeeSerializer.new object.other(scope)
  end
end