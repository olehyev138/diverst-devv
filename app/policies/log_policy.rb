class LogPolicy < ApplicationPolicy
  def index?
    return true if manage_all?
    @policy_group.logs_view?
  end
end
