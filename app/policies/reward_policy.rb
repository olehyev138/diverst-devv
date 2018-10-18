class RewardPolicy < ApplicationPolicy
  
  def index?
      manage?
  end
  
  def new?
      manage?
  end

  def create?
      manage?
  end
  
  def manage?
    return true if manage_all?
    @policy_group.diversity_manage?
  end

  def update?
      manage?
  end

  def destroy?
      manage?
  end

end
