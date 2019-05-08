class MetricsDashboardPolicy < ApplicationPolicy
  def index?
    return true if create?
    return true if basic_group_leader_permission?('metrics_dashboards_index')

    @policy_group.metrics_dashboards_index?
  end

  def show?
    return true if manage_all?
    return true if @record.owner_id === @user.id

    @record.is_user_shared?(@user)
  end

  def edit?
    update?
  end

  def new?
    create?
  end

  def create?
    return true if manage_all?
    return true if basic_group_leader_permission?('metrics_dashboards_create')

    @policy_group.metrics_dashboards_create?
  end

  def update?
    return true if manage_all?

    @record.owner_id === @user.id
  end

  def destroy?
    return true if manage_all?
    return true if @record.owner_id === @user.id

    @record.is_user_shared?(@user)
  end

  class Scope < Scope
    def index?
      MetricsDashboardPolicy.new(user, nil).index?
    end

    def resolve
      if index?
        scope.with_shared_dashboards(user.id).order(created_at: :desc)
      else
        scope.none
      end
    end
  end
end
