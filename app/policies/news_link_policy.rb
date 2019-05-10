class NewsLinkPolicy < ApplicationPolicy
  def index?
    return true if create?
    return true if basic_group_leader_permission?('news_links_index')

    @policy_group.news_links_index?
  end

  def show?
    index?
  end

  def create?
    return true if manage?
    return true if basic_group_leader_permission?('news_links_create')

    @policy_group.news_links_create?
  end

  def manage?
    return true if manage_all?
    return true if basic_group_leader_permission?('news_links_manage')

    @policy_group.news_links_manage?
  end

  def update?
    return true if manage?

    @record.author == @user
  end

  def destroy?
    update?
  end
end
