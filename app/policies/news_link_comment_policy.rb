class NewsLinkCommentPolicy < GroupBasePolicy
  def index?
    case record
    when NewsLinkComment then true
    else NewsFeedLinkPolicy.new(user, NewsFeedLink, params).show?
    end
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