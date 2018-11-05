class InitiativeCommentPolicy < ApplicationPolicy
  def erg_leader?
    return true if manage_all?
    return true if basic_group_leader_permission?("manage_posts")
    @policy_group.manage_posts?
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