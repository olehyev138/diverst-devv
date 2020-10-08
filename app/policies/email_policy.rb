class EmailPolicy < ApplicationPolicy
  def index?
    manage?
  end

  def show?
    manage?
  end

  def create?
    false
  end

  def update?
    manage?
  end

  def destroy?
    false
  end

  def manage?
    EnterprisePolicy.new(user, Enterprise).manage_branding?
  end

  class Scope < Scope
    def index?
      EmailPolicy.new(user, nil).index?
    end

    def resolve
      if index?
        scope.where(enterprise_id: user.enterprise_id)
      else
        scope.none
      end
    end
  end
end
