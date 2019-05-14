class SocialLinkPolicy < ApplicationPolicy
  def index?
    return true if manage?
    return true if basic_group_leader_permission?('social_links_index')

    @policy_group.social_links_index?
  end

  def create?
    return true if manage?
    return true if basic_group_leader_permission?('social_links_create')

    @policy_group.social_links_create?
  end

  def manage?
    return true if manage_all?
    return true if basic_group_leader_permission?('social_links_manage')

    @policy_group.social_links_manage?
  end

  def update?
    return true if manage?

    @record.author == @user
  end

  def destroy?
    return true if manage?

    @record.author == @user
  end

  class Scope < Scope
    def index?
      SocialLinkPolicy.new(user, nil).index?
    end

    def resolve
      if index?
        scope.where(author_id: user.id)
      else
        scope.none
      end
    end
  end
end
