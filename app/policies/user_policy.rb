class UserPolicy < ApplicationPolicy
  def index?
    @policy_group.global_settings_manage?
  end

  def create?
    @policy_group.global_settings_manage?
  end

  def update?
    @policy_group.global_settings_manage?
  end

  def destroy?
    @policy_group.global_settings_manage?
  end
end
