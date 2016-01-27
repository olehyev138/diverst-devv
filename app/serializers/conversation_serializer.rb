class ConversationSerializer < ActiveModel::Serializer
  attributes :id,
    :saved,
    :expires_soon,
    :user,
    :expiration_date

  def user
    EmployeeSerializer.new object.other(scope)
  end

  def saved
    object.saved?
  end

  def expires_soon
    object.expires_soon_for?(employee: scope)
  end
end
