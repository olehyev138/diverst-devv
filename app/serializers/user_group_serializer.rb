class UserGroupSerializer < ApplicationRecordSerializer
  attributes :id, :user_id, :group_id, :user, :group, :total_weekly_points, :data, :accepted_member,
             :created_at, :updated_at

  def user
    UserSerializer.new(object.user).attributes
  end

  def group
    GroupSerializer.new(object.group).attributes
  end
end
