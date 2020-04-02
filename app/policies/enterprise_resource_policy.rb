class EnterpriseResourcePolicy < ApplicationPolicy
  def index?
    return true if create?
    return true if basic_group_leader_permission?('enterprise_resources_index')

    @policy_group.enterprise_resources_index?
  end

  def create?
    return true if update?
    return true if basic_group_leader_permission?('enterprise_resources_create')

    @policy_group.enterprise_resources_create?
  end

  def edit?
    update?
  end

  def update?
    return true if manage_all?
    return true if basic_group_leader_permission?('enterprise_resources_manage')

    @policy_group.enterprise_resources_manage?
  end

  def destroy?
    update?
  end

  class Scope < Scope
    def index?
      EnterpriseResourcePolicy.new(user, nil).index?
    end

    def resolve
      if index?
        scope.where(enterprise_id: user.enterprise_id)
      else
        scope.none
      end
    end
  end
end
