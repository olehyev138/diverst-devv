class EventPolicy < ApplicationPolicy
  def index?
    @policy_group.events_index?
  end

  def create?
    @policy_group.events_create?
  end

  def update?
    return true if @policy_group.events_manage?
    @record.owner == @user
  end

  def destroy?
    return true if @policy_group.events_manage?
    @record.owner == @user
  end
end
