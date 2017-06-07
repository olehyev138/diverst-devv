module GroupsHelper
  def group_performance_label(group)
    label =
      if group == @group
        group.name
      else
        link_to group.name, group
      end
    label += " (#{ group.participation_score_7days })" if ENV['REWARDS_ENABLED']
  end
end
