class PollPolicy < ApplicationPolicy
  def index?
    return false unless scope_module_enabled?
    return true if create?
    @policy_group.polls_index?
  end

  def create?
    return false unless scope_module_enabled?
    return true if manage?
    @policy_group.polls_create?
  end
  
  def manage?
    return true if manage_all?
    @policy_group.polls_manage?
  end

  def update?
    return false unless scope_module_enabled?
    return true if manage?
    @record.owner == @user
  end

  def destroy?
    update?
  end

  class Scope < Scope 
    def index?
      PollPolicy.new(user, nil).index?
    end
    
    def resolve
      if index?
        scope.where(enterprise_id: user.enterprise_id).order(created_at: :desc)
      else
        []
      end
    end
  end

  private

  def scope_module_enabled?
    return @user.enterprise.scope_module_enabled
  end
end
