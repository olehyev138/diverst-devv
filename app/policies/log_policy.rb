class LogPolicy < ApplicationPolicy
  def index?
    return true if manage_all?
    return true if basic_group_leader_permission?('logs_view')

    @policy_group.logs_view?
  end
end
