class UserPolicy < ApplicationPolicy
  def index?
    return true if create?
    return true if basic_group_leader_permission?('users_index')

    @policy_group.users_index?
  end

  def budget_approvers?
    BudgetPolicy.new(@user, AnnualBudget, @params).create?
  end

  def show?
    return true if manage?

    @record === @user
  end

  def create?
    manage?
  end

  def manage?
    return true if manage_all?
    return true if basic_group_leader_permission?('users_manage')

    @policy_group.users_manage?
  end

  def update?
    return true if manage?

    @record === @user
  end

  def destroy?
    return false if @user === @record
    return false unless @record.can_be_destroyed

    update?
  end

  def resend_invitation?
    create?
  end

  def access_hidden_info?
    return true if @record == @user

    create?
  end

  def user_not_current_user?
    @user != @record
  end

  def users_points_ranking?
    create?
  end

  def users_points_csv?
    users_points_ranking?
  end

  def users_pending_rewards?
    users_points_ranking?
  end

  alias_method :prototype?, :create?

  class Scope < Scope
    def index?
      UserPolicy.new(user, nil).index?
    end

    def resolve
      if index?
        scope.where(enterprise_id: user.enterprise_id)
      elsif policy.budget_approvers?
        scope.where(enterprise_id: user.enterprise_id)
      else
        scope.none
      end
    end
  end
end
