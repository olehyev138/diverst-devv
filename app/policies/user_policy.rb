class UserPolicy < ApplicationPolicy
  def index?
    @policy_group.users_index?
  end

  def create?
    @policy_group.users_manage?
  end

  def update?
    return true if @record == @user
    @policy_group.users_manage?
  end

  def destroy?
    @policy_group.users_manage?
  end

  def resend_invitation?
    @policy_group.users_manage?
  end

  def access_hidden_info?
    return true if @record == @user

    @policy_group.users_manage?
  end

  def join_or_leave_groups?
    return true if @record == @user
    return true if GroupPolicy.new(@record, @user).manage_members?
    false
  end
end
