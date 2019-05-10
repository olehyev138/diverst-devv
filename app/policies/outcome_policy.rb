class OutcomePolicy < ApplicationPolicy
  def index?
    return true if create?
    return true if basic_group_leader_permission?('initiatives_index')

    @policy_group.initiatives_index?
  end

  def create?
    return true if manage?
    return true if basic_group_leader_permission?('initiatives_create')

    @policy_group.initiatives_create?
  end

  def manage?
    return true if manage_all?
    return true if basic_group_leader_permission?('initiatives_manage')

    @policy_group.initiatives_manage?
  end

  def update?
    return true if manage?

    @record.group.owner == @user
  end

  def destroy?
    return true if manage?

    @record.group.owner == @user
  end
end
