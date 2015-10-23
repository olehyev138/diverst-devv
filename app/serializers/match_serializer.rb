class MatchSerializer < ActiveModel::Serializer
  attributes :id,
    :user,
    :topic

  def user
    EmployeeSerializer.new object.other(scope)
  end

  def topic
    TopicSerializer.new object.topic
  end
end
