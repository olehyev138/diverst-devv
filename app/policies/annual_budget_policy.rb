class AnnualBudgetPolicy < ApplicationPolicy
  def index?
    true
  end

  class Scope < Scope
    def index?
      AnnualBudgetPolicy.new(user, nil).index?
    end

    def resolve
      if index?
        scope.joins(:enterprise).where('enterprises.id = ?', user.enterprise_id)
      else
        scope.none
      end
    end
  end
end
