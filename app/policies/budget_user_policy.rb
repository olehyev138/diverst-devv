class BudgetUserPolicy < ApplicationPolicy
  def index
    false
  end

  def show?
    false
  end

  def create?
    false
  end

  def update?
    false
  end

  class Scope < Scope
    def resolve
      scope.none
    end
  end
end
