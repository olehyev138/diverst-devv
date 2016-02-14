class CampaignPolicy < ApplicationPolicy
  def index?
    @policy_group.campaigns_index?
  end

  def create?
    @policy_group.campaigns_create?
  end

  def update?
    return true if @policy_group.campaigns_manage?
    @record.owner == @user
  end

  def destroy?
    return true if @policy_group.campaigns_manage?
    @record.owner == @user
  end
end
