class NewsLinkPolicy < ApplicationPolicy
  def index?
    @policy_group.news_links_index?
  end

  def create?
    @policy_group.news_links_create?
  end

  def update?
    return true if @policy_group.news_links_manage?
    @record.owner == @user
  end

  def destroy?
    return true if @policy_group.news_links_manage?
    @record.owner == @user
  end
end
