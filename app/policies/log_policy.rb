class LogPolicy < ApplicationPolicy
  def index?
    @policy_group.logs_view?
  end
end
