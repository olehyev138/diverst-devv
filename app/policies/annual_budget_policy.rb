class AnnualBudgetPolicy < GroupBasePolicy
  def initialize(user, context, params = {})
    super
    if group
      @parent = group.parent
      if @parent
        @parent_leader = user.policy_group_leader(@parent.id)
        @parent_member = user.policy_user_group(@parent.id)
      end
    end
  end

  def is_a_member?
    super || @parent_member.present?
  end

  def is_an_accepted_member?
    super || @parent_member&.accepted_member?
  end

  def is_a_leader?
    group_leader.present? || region_leader.present? || @parent_leader.present?
  end

  def has_group_leader_permissions?(permission)
    if is_a_leader?
      group_leader&.[](permission) ||
      region_leader&.[](permission) ||
      @parent_leader&.[](permission) ||
      false
    else
      false
    end
  end
  
  def base_index_permission
    'groups_budgets_index'
  end

  def base_create_permission
    'groups_budgets_request'
  end

  def base_manage_permission
    'groups_budgets_manage'
  end

  def group_of(object)
    g = params[:group_id].present? ? Group.find(params[:group_id]) : object.group
    return nil unless g.is_child_of(object.budget_head) || g == object.budget_head

    g
  end

  def index?
    super || BudgetPolicy.new(user, [group, Budget]).index?
  end

  def manage?
    super || BudgetPolicy.new(user, Budget).manage_all_budgets?
  end

  alias_method :reset_budgets?, :manage?

  class Scope < Scope
    def group_base
      group.all_annual_budgets
    end

    def resolve
      if group.present?
        super(policy.base_index_permission)
      else
        scope.none
      end
    end
  end
end
