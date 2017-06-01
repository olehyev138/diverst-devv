class OutcomePolicy < ApplicationPolicy
  def index?
    return true if @policy_group.initiatives_index?

    @user.erg_leader?
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