class SocialLinkPolicy < ApplicationPolicy
  def create?
    @policy_group.news_links_create?
  end

  def update?
    return true if is_owner?
    return false if @record.news_feed_link.share_links.count > 1

    manage?
  end

  def destroy?
    manage?
  end

  def manage?
    return true if is_owner?

    @policy_group.news_links_manage?
  end

  def is_owner?
    @record.author == @user
  end
end
