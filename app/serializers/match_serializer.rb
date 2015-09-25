class MatchSerializer < ActiveModel::Serializer
  attributes :id,
    :expires_soon,
    :user

  def user
    EmployeeSerializer.new object.other(scope)
  end

  def expires_soon
    object.expires_soon?
  end
end
