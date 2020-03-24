class GroupMessageCommentPolicy < GroupBasePolicy
  def index?
    NewsFeedLinkPolicy.new(user, record.news_feed_link).show?
  end

  def update?
    record.author == user || manage_comments?
  end

  def create?
    index?
  end

  def destroy?
    update?
  end
end
