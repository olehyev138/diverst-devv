class CampaignPolicy < ApplicationPolicy
  def index?
    return false unless collaborate_module_enabled?

    @policy_group.campaigns_index?
  end

  def create?
    return false unless collaborate_module_enabled?

    @policy_group.campaigns_create?
  end

  def update?
    return false unless collaborate_module_enabled?

    return true if @policy_group.campaigns_manage?
    @record.owner == @user
  end

  def destroy?
    return false unless collaborate_module_enabled?

    return true if @policy_group.campaigns_manage?
    @record.owner == @user
  end

  private

  def collaborate_module_enabled?
    return @user.enterprise.collaborate_module_enabled
  end
end
