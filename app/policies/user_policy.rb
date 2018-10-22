class UserPolicy < ApplicationPolicy
  def index?
    return true if create?
    @policy_group.users_index?
  end

  def create?
    @policy_group.users_manage?
  end

  def update?
    return true if create?
    @record === @user
  end

  def destroy?
    update?
  end

  def resend_invitation?
    create?
  end

  def access_hidden_info?
    return true if @record == @user

    create?
  end

  def join_or_leave_groups?
    return true if @record == @user
    return true if GroupPolicy.new(@record, @user).manage_members?
    false
  end
  
  class Scope < Scope 
    def index?
      UserPolicy.new(user, nil).index?
    end
    
    def resolve
      if index?
        scope.where(enterprise_id: user.enterprise_id)
      else
        []
      end
    end
  end
end
