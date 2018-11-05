class ExpenseCategoryPolicy < ApplicationPolicy

  def index?
    return true if manage_all?
    @policy_group.campaigns_manage?
  end

  def create?
    index?
  end

  def update?
    index?
  end

  def destroy?
    index?
  end

  class Scope < Scope

    def index?
      ExpenseCategoryPolicy.new(user, nil).index?
    end

    def resolve
      if index?
        scope.where(:enterprise_id => user.enterprise_id)
      else
        []
      end
    end
  end
end
