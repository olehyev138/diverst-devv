class MetricsDashboardPolicy < ApplicationPolicy
  def index?
    true
  end

  def create?
    true
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope.where(owner: user)
    end
  end
end
