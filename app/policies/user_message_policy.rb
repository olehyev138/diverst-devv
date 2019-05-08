class UserMessagePolicy < ApplicationPolicy
  def index?
    return true if create?
    return true if basic_group_leader_permission?('group_messages_index')

    @policy_group.group_messages_index?
  end

  def show?
    index?
  end

  def create?
    return true if manage?
    return true if basic_group_leader_permission?('group_messages_create')

    @policy_group.group_messages_create?
  end

  def manage?
    return true if manage_all?
    return true if basic_group_leader_permission?('group_messages_manage')

    @policy_group.group_messages_manage?
  end

  def update?
    return true if manage?

    @record.author == @user
  end

  def destroy?
    update?
  end
end
