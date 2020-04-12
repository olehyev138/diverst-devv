class CampaignPolicy < ApplicationPolicy
  def index?
    return false unless collaborate_module_enabled?
    return true if create?
    return true if basic_group_leader_permission?('campaigns_index')

    @policy_group.campaigns_index?
  end

  def new?
    create?
  end

  def create?
    return false unless collaborate_module_enabled?
    return true if manage?
    return true if basic_group_leader_permission?('campaigns_create')

    @policy_group.campaigns_create?
  end

  def manage?
    return true if manage_all?
    return true if basic_group_leader_permission?('campaigns_manage')

    @policy_group.campaigns_manage?
  end

  def update?
    return false unless collaborate_module_enabled?
    return true if manage?

    @record.owner == @user
  end

  def destroy?
    update?
  end

  def show?
    update?
  end

  class Scope < Scope
    def index?
      CampaignPolicy.new(user, nil).index?
    end

    def resolve
      if index?
        scope.where(enterprise_id: user.enterprise_id)
      else
        scope.none
      end
    end
  end

  private

  def collaborate_module_enabled?
    @user.enterprise.collaborate_module_enabled
  end
end
