class PolicyGroupTemplatePolicy < ApplicationPolicy
  def index?
    UserRolePolicy.new(user, UserRole).index?
  end

  def new?
    create?
  end

  def create?
    false
  end

  def update?
    UserRolePolicy.new(user, UserRole).update?
  end

  def destroy?
    false
  end

  def show?
    index?
  end

  class Scope < Scope
    def resolve
      if policy.index?
        scope.left_joins(:user_role).where(user_roles: { enterprise_id: user.enterprise_id })
      else
        scope.none
      end
    end
  end
end
