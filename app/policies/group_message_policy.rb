class GroupMessagePolicy < ApplicationPolicy
  def index?
    @policy_group.group_messages_index?
  end

  def create?
    @policy_group.group_messages_create?
  end

  def destroy?
    return true if @record.owner == @user

    @policy_group.group_messages_manage
  end
end