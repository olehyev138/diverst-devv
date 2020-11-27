class UserRolePolicy < ApplicationPolicy
  def index?
    return true if create?
    return true if basic_group_leader_permission?('users_index')
    return true if basic_group_leader_permission?('group_leader_manage')
    return true if user.group_leaders.any?(&:group_leader_manage?)
    return true if basic_group_leader_permission?('users_manage')
    return true if @policy_group.users_manage?
    return true if @policy_group.group_leader_manage?

    @policy_group.users_index?
  end

  def new?
    create?
  end

  def create?
    return true if manage_all?
    return true if basic_group_leader_permission?('permissions_manage')

    @policy_group.permissions_manage?
  end

  def update?
    create?
  end

  def destroy?
    create? && @record.can_destroy?
  end

  def show?
    index?
  end

  class Scope < Scope
    def index?
      UserRolePolicy.new(user, nil).index?
    end

    def resolve
      if index?
        if policy_group.manage_all? || policy_group.users_manage? || policy_group.users_index?
          scope.where(enterprise_id: user.enterprise_id).all
        else
          scope.where(enterprise_id: user.enterprise_id, role_type: 'group')
        end
      else
        scope.none
      end
    end
  end
end
