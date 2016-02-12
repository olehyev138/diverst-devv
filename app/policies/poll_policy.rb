class PollPolicy < ApplicationPolicy
  def index?
    @policy_group.polls_index?
  end

  def create?
    @policy_group.polls_create?
  end

  def update?
    return true if @policy_group.polls_manage?
    @record.owner == @user
  end

  def destroy?
    return true if @policy_group.polls_manage?
    @record.owner == @user
  end
end
