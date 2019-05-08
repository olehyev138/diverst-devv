class GroupLeaderCommentNotificationsJob < ActiveJob::Base
  queue_as :mailers

  def perform(group_id)
    group = Group.find_by_id(group_id)
    return if group.nil?

    # get the pending comments count
    count = group.enterprise.enable_pending_comments? ? group.pending_comments_count : 0

    # check if group has pending comments
    return if count < 1

    # get the leaders
    leaders = group.leaders.joins(:group_leaders).where(group_leaders: { pending_comments_notifications_enabled: true }).distinct
    # send an email to group leaders with notifications enabled
    leaders.each do |leader|
      GroupLeaderCommentNotificationMailer.notification(group, leader, count).deliver_now
    end
  end
end
