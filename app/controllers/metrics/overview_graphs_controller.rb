class Metrics::OverviewGraphsController < ApplicationController
  include Metrics

  layout 'metrics'

  def index
    authorize MetricsDashboard

    enterprise = current_user.enterprise
    @general_metrics = {
      nb_users: enterprise.users.active.count,
      nb_ergs: enterprise.groups.count,
      nb_segments: enterprise.segments.count,
      nb_resources: enterprise.resources_count,
      nb_polls: enterprise.polls.count,
      nb_ongoing_campaigns: enterprise.campaigns.ongoing.count,
      average_nb_members_per_group: Group.avg_members_per_group(enterprise: enterprise)
    }

    @user_metrics = {
      user_growth: @graph.user_change_percentage,
      group_memberships: @graph.group_memberships
    }

    @innovation_metrics = {
      total_campaigns: enterprise.campaigns.where('created_at <= ?', 1.month.ago).count
    }

    @poll_metrics = {
      total_polls: enterprise.polls.where('created_at <= ?', 1.month.ago).count
    }

    @mentorship_metrics = {
      mentoring_sessions: enterprise.mentoring_sessions.where('start <= ?', 1.month.ago).count,
      active_mentorships: Mentoring.active_mentorships(enterprise).count
    }
  end
end