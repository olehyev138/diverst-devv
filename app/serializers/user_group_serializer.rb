class UserGroupSerializer < ApplicationRecordSerializer
  attributes :user, :group
  
  def user
    UserSerializer.new(object.user).attributes
  end
  
  def group
    GroupSerializer.new(object.group).attributes
  end
end
