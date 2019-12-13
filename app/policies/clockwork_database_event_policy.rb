class ClockworkDatabaseEventPolicy < EnterprisePolicy
  def index?
    update?
  end

  def show?
    update?
  end

  class Scope < Scope
    def index?
      ClockworkDatabaseEventPolicy.new(user, nil).index?
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
