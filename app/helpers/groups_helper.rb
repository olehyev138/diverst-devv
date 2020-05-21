module GroupsHelper
  def group_performance_label(group)
    label =
      if group == @group
        group.name
      else
        link_to group.name, group
      end
    label += " (#{ group.total_weekly_points })" if group.enterprise.enable_rewards?

    label
  end

  def show_members_link?(group)
    return true if GroupMemberPolicy.new(current_user, [group]).view_members?
    return true if group.pending_users.enabled? && GroupMemberPolicy.new(current_user, [group]).update?

    false
  end

  def show_manage_link?(group)
    return true if GroupLeaderPolicy.new(current_user, [group]).index?
    return true if GroupPolicy.new(current_user, group).insights?
    return true if GroupPolicy.new(current_user, group).layouts?
    return true if GroupPolicy.new(current_user, group).manage?
    return true if GroupPolicy.new(current_user, group).settings?

    false
  end

  def show_plan_link?(group)
    return true if GroupBudgetPolicy.new(current_user, [group]).index?
    return true if GroupEventsPolicy.new(current_user, [group]).update?
    return true if GroupBudgetPolicy.new(current_user, [group]).update?
    return true if GroupPolicy.new(current_user, group).manage?

    false
  end
end
