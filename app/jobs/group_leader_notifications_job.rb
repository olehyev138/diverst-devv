class GroupLeaderNotificationsJob < ActiveJob::Base
  queue_as :default

  def perform(group)
    # get the pending members count
    pending_members_count = group.pending_members.count
    # get the pending members count
    pending_comments_count = group.enterprise.enable_pending_comments? ? group.pending_comments_count : 0
    # check if group has pending members/comments
    return if pending_members_count < 1 and pending_comments_count < 1

    # get the leaders
    leaders = group.leaders.joins(:group_leaders).where(:group_leaders => {:notifications_enabled => true}).distinct
    # send an email to group leaders with notifications enabled

    leaders.each do |leader|
      GroupLeaderNotificationMailer.notification(group, leader, pending_members_count, pending_comments_count).deliver_now
    end
  end
end
