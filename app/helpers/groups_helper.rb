module GroupsHelper
  def group_performance_label(group)
    label =
      if group == @group
        group.name
      else
        link_to group.name, group
      end
    label += " (#{ group.total_weekly_points })" if group.enterprise.enable_rewards?
  end
end
