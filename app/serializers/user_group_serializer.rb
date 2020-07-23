class UserGroupSerializer < ApplicationRecordSerializer
  attributes :id, :user_id, :group_id, :user, :group, :total_weekly_points, :data, :accepted_member,
             :created_at, :updated_at, :status

  def user
    UserSerializer.new(object.user, scope: scope).attributes
  end

  def status
    unless object.user.active
      return 'inactive'
    end
    if object.group.pending_users == 'enabled' && !object.accepted_member
      return 'pending'
    end

    'active'
  end
end
