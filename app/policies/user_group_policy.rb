class UserGroupPolicy < ApplicationPolicy
  def index?
    return true if create?
    return true if basic_group_leader_permission?('groups_index')

    @policy_group.groups_index?
  end

  def show?
    index?
  end

  def create?
    false
  end

  def update?
    false
  end

  def destroy?
    false
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
