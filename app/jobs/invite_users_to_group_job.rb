class InviteUsersToGroupJob < ActiveJob::Base
  queue_as :mailers
  include Rewardable

  def perform(group_id, user_id, invited_by_id)
    return if group_id.nil? || user_id.nil?


    invited_by = User.find_by(id: invited_by_id)
    user_group = UserGroup.find_or_create_by(group_id: group_id, user_id: user_id)

    user_group&.update(invitation_sent_at: DateTime.now, invited_by: invited_by.name)
    user_rewarder(invited_by, 'group_invite').add_points(user_group)

    GroupInvitationMailer.invitation(group_id, user_id).deliver_later
  end
end
