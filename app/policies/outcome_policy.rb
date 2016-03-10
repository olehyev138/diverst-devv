class OutcomePolicy < ApplicationPolicy
  def index?
    @policy_group.initiatives_index?
  end

  def create?
    @policy_group.initiatives_manage?
  end

  def update?
    return true if @policy_group.initiatives_manage?
    @record.owner == @user
  end

  def destroy?
    return true if @policy_group.initiatives_manage?
    @record.owner == @user
  end
end