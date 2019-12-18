class InitiativeCommentPolicy < ApplicationPolicy
  def erg_leader?
    return true if manage_all?
    return true if basic_group_leader_permission?('manage_posts')

    @policy_group.manage_posts?
  end

  # move this to GroupBasePolicy and re-define #basic_group_leader_permission?
  def manage_comments?
    return true if manage_all?
    return true if GroupLeader.where(user_id: user.id, group_id: record.initiative.owner_group.id).exists?

    @policy_group.manage_posts?
    return true if record.user == user
  end

  def approve?
    erg_leader?
  end

  def disapprove?
    erg_leader?
  end

  def destroy?
    erg_leader?
  end
end
