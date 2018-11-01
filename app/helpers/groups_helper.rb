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
    GroupMemberPolicy.new(current_user, [group]).view_members? || group.pending_users.enabled? && GroupMemberPolicy.new(current_user, [group]).update?
  end
end
