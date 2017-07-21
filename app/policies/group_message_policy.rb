class GroupMessagePolicy < ApplicationPolicy
  def index?
    @policy_group.group_messages_index?
  end

  def create?
    @policy_group.group_messages_create?
  end

  def update?
    return true if is_owner?
  end

  def destroy?
    return true if is_owner?

    @policy_group.group_messages_manage
  end

  def is_owner?
    @record.owner == @user
  end
end
