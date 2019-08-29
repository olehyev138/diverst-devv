class Api::V1::Metrics::OverviewGraphsController < DiverstController
  include Api::V1::Concerns::Metrics

  def overview_metrics
    render json: {
      general: {
        nb_users: enterprise.users.active.count,
        nb_ergs: enterprise.groups.size,
        nb_segments: enterprise.segments.size,
        nb_resources: enterprise.resources_count,
        nb_polls: enterprise.polls.size,
        nb_ongoing_campaigns: enterprise.campaigns.ongoing.count,
        average_nb_members_per_group: Group.avg_members_per_group(enterprise: enterprise)
      },
      user: {
        user_growth: @graph.user_change_percentage,
        group_memberships: @graph.group_memberships
      },
      innovation: {
        total_campaigns: enterprise.campaigns.where('created_at <= ?', 1.month.ago).count
      },
      mentorship: {
        mentoring_sessions: enterprise.mentoring_sessions.where('start <= ?', 1.month.ago).count,
        active_mentorships: Mentoring.active_mentorships(enterprise).count
      }
    }
  end
end
