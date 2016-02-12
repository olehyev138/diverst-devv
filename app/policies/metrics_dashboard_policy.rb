class MetricsDashboardPolicy < ApplicationPolicy
  def index?
    @policy_group.metrics_dashboards_index?
  end

  def create?
    @policy_group.metrics_dashboards_create?
  end

  class Scope < Scope
    def resolve
      scope.where(owner: user)
    end
  end
end
