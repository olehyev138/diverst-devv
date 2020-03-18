class UserGroupPolicy < ApplicationPolicy
  def index?
    return true if manage_all?
    return true if basic_group_leader_permission?('groups_members_index')

    @policy_group.groups_members_index?
  end

  def show?
    index?
  end

  def create?
    true
  end

  def update?
    true
  end

  def destroy?
    true
  end

  class Scope < Scope
    def index?
      UserGroupPolicy.new(user, nil).index?
    end

    def resolve
      if index?
        scope.where(groups: { enterprise_id: user.enterprise_id }).all
      else
        scope.none
      end
    end
  end
end
