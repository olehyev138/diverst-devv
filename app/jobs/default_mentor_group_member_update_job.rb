class DefaultMentorGroupMemberUpdateJob < ActiveJob::Base
  queue_as :default

  # this job runs after a user updates their user account and checks whether mentee/mentor attributes were
  # updated. if either fields are set to true

  def perform(user_id, mentor, mentee)
    user = User.find_by_id(user_id)
    return if user.nil?

    group = Group.where(enterprise_id: user.enterprise_id, default_mentor_group: true).first
    return if group.nil?

    # if mentee and mentor are both false then remove the user from the group
    if !mentee && !mentor
      UserGroup.where(group_id: group.id, user_id: user.id).destroy_all
    else
      # check if the user is a member of the group
      user_group = UserGroup.where(group_id: group.id, user_id: user.id).first

      if user_group.nil?
        UserGroup.create!(group_id: group.id, user_id: user_id, accepted_member: group.pending_users.disabled?)
      end
    end
  end
end
