class PolicyGroupPolicy < ApplicationPolicy
  def index?
    can_manage_global_settings?
  end

  def new?
    can_manage_global_settings?
  end

  def create?
    can_manage_global_settings?
  end

  def update?
    can_manage_global_settings?
  end

  def destroy?
    can_manage_global_settings?
  end

  protected

  def can_manage_global_settings?
    @policy_group.global_settings_manage?
  end
end
