class GroupLeaderNotificationsJob < ActiveJob::Base
  queue_as :default

  def perform(group)
    # get the pending members count
    count = group.pending_members.count
    # check if group has pending members
    return if count < 1
    # get the leaders
    leaders = group.leaders.joins(:group_leaders).where(:group_leaders => {:notifications_enabled => true})
    # send an email to group leaders with notifications enabled
    leaders.each do |leader|
      GroupLeaderNotificationMailer.notification(group, leader, count).deliver_now
    end
  end
end
