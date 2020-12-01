class GroupTwitterFeedPolicy < GroupBasePolicy
  def index?
    return true if group.enterprise.twitter_feed_enabled?
  end
end