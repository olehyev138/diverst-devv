class SocialLinkPolicy < ApplicationPolicy
  def create?
    @policy_group.news_links_create?
  end

  def manage?
    return true if @policy_group.news_links_manage?
    @record.author == @user
  end

  def update?
    manage?
  end

  def destroy?
    manage?
  end
end
