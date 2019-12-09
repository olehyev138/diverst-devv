class EmailPolicy < CampaignPolicy
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

  class Scope < Scope
    def index?
      ExpensePolicy.new(user, nil).index?
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
