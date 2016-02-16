class NewsLinkPolicy < ApplicationPolicy
  def index?
    @policy_group.group_messages_index?
  end

  def create?
    @policy_group.group_messages_create?
  end

  def destroy?
    return true if @policy_group.polls_manage?
  end
end
