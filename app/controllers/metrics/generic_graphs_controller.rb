class Metrics::GenericGraphsController < ApplicationController
  layout 'metrics'

  def index
    authorize MetricsDashboard

    @dashboards = policy_scope(MetricsDashboard).includes(:enterprise, :segments)

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
  end
end
