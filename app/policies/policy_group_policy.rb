class PolicyGroupPolicy < ApplicationPolicy
  def create?
    @policy_group.global_settings_manage?
  end

  def destroy?
    @policy_group.global_settings_manage?
  end
end
