class PollPolicy < ApplicationPolicy
  def index?
    return false unless scope_module_enabled?

    @policy_group.polls_index?
  end

  def create?
    return false unless scope_module_enabled?

    @policy_group.polls_create?
  end

  def update?
    return false unless scope_module_enabled?

    return true if @policy_group.polls_manage?
    @record.owner == @user
  end

  def destroy?
    return false unless scope_module_enabled?

    return true if @policy_group.polls_manage?
    @record.owner == @user
  end

  class Scope < Scope 
    def resolve
      scope.where(enterprise: @user.enterprise).order(created_at: :desc)
    end
  end

  private

  def scope_module_enabled?
    return @user.enterprise.scope_module_enabled
  end
end
