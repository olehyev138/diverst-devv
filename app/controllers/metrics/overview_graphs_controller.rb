class Metrics::OverviewGraphsController < ApplicationController
  include Metrics

  after_action :visit_page, only: [:index]

  layout 'metrics'

  def index
    authorize MetricsDashboard

    enterprise = current_user.enterprise
    @general_metrics = {
      nb_users: enterprise.users.active.count,
      nb_ergs: enterprise.groups.size,
      nb_segments: enterprise.segments.size,
      nb_resources: enterprise.resources_count,
      nb_polls: enterprise.polls.size,
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

  def visit_page
    super(page_name)
  end

  def page_name
    case action_name
    when 'index'
      'Overview Metrics'
    else
      "#{controller_path}##{action_name}"
    end
  rescue
    "#{controller_path}##{action_name}"
  end
end
