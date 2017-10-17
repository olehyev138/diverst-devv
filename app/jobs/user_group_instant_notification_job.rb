class UserGroupInstantNotificationJob < ActiveJob::Base
  queue_as :default

  # it seems like the count will always be one or 0 so its
  # best we just pass in the event and check if users
  # are in the event's segment if one exists

  def perform(group, link: nil, link_type: nil)
    return if link.nil?
    return if link_type.nil?
    
    @link = link
    @link_type = link_type

    User
      .joins(user_groups: :group)
      .joins(joins)
      .where(where)
      .where(groups: { id: group.id })
      .where(user_groups: { notifications_frequency: UserGroup.notifications_frequencies[:real_time] })
      .find_in_batches(batch_size: 200).each do |users|
        users.each do |user|
          groups = [{ group: group, messages_count: messages_count, news_count: news_count }]
          UserGroupMailer.notification(user, groups).deliver_now
        end
      end
  end
  
  def segment_ids
    @link.news_feed_link.news_feed_link_segments.pluck(:segment_id)
  end
  
  def where
    return {} if segment_ids.empty?
    return "users_segments.segment_id IN (#{segment_ids.join(",")})"
  end
  
  def joins
    "LEFT JOIN users_segments ON users_segments.user_id = users.id"
  end
  
  def news_count
    return 0 if @link_type != "NewsLink"
    return 1 if @link_type === "NewsLink"
  end
  
  def messages_count
    return 0 if @link_type != "GroupMessage"
    return 1 if @link_type === "GroupMessage"
  end
end
