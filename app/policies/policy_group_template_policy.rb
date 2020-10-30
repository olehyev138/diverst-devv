class PolicyGroupTemplatePolicy < ApplicationPolicy
  def index?
    create? || UserPolicy.new(user, User).create?
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
    create?
  end

  def show?
    index?
  end

  class Scope < Scope
    def resolve
      if index?
        scope.left_joins(:user_role).where(user_roles: { enterprise_id: user.enterprise_id })
      else
        scope.none
      end
    end
  end
end
