class GroupMessagePolicy < ApplicationPolicy
  def index?
    @policy_group.group_messages_index?
  end

  def create?
    @policy_group.group_messages_create?
  end

  def update?
    return true if is_owner?
    return false if @record.news_feed_link.share_links.count > 1

    manage?
  end

  def destroy?
    manage?
  end

  def manage?
    return true if is_owner?

    @policy_group.group_messages_manage
  end

  def is_owner?
    @record.owner == @user
  end
end
