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
    return true if basic_group_leader_permission?('diversity_manage')

    @policy_group.diversity_manage?
  end

  def update?
    manage?
  end

  def destroy?
    manage?
  end

  def user_responsible?
    return true if @record.responsible_id == @user.id
  end
end
