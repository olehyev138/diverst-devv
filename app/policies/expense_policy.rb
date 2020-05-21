class ExpensePolicy < CampaignPolicy
  def update?
    return false unless collaborate_module_enabled?

    manage?
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
