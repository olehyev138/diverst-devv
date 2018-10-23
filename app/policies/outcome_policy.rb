class OutcomePolicy < ApplicationPolicy
  def index?
    return true if create?
    @policy_group.initiatives_index?
  end

  def create?
    return true if manage?
    @policy_group.initiatives_create?
  end
  
  def manage?
    return true if manage_all?
    @policy_group.initiatives_manage?
  end

  def update?
    return true if manage?
    @record.owner == @user
  end

  def destroy?
    return true if manage?
    @record.owner == @user
  end
end