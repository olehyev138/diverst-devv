class GroupLeaderMemberNotificationsJob < ActiveJob::Base
  queue_as :mailers

  def perform(group_id)
    group = Group.find_by_id(group_id)
    return if group.nil?

    # get the pending members count
    count = group.pending_members.count
    # check if group has pending members
    return if count < 1

    # get the leaders
    leaders = group.leaders.joins(:group_leaders).where(group_leaders: { pending_member_notifications_enabled: true }).distinct
    # send an email to group leaders with notifications enabled
    leaders.each do |leader|
      GroupLeaderMemberNotificationMailer.notification(group, leader, count).deliver_now
    end
  end
end
