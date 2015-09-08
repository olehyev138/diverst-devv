class MatchSerializer < ActiveModel::Serializer
  attributes :id,
    :user

  def user
    EmployeeSerializer.new object.other(scope)
  end
end
