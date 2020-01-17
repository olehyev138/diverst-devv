class GroupUpdatePolicy < ApplicationPolicy
  def index?
    manage?
  end

  def show?
    manage?
  end

  def create?
    manage?
  end

  def manage?
    return true if manage_all?
    return true if basic_group_leader_permission?('manage')

    @policy_group.manage?
  end

  def update?
    manage?
  end

  def destroy?
    manage?
  end

  class Scope < Scope
    def resolve
      scope.joins(:group).where(
        groups: {
          enterprise_id: @user.enterprise.id
        }
      )
    end
  end
end
