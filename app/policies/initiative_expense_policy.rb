class InitiativeExpensePolicy < GroupBasePolicy
  def base_index_permission
    'initiatives_index'
  end

  def base_create_permission
    'initiatives_manage'
  end

  def base_manage_permission
    'initiatives_manage'
  end

  def get_group_id(context, param = :budget_user_id)
    budget_user_id = params[param] || params.dig(context.model_name.param_key.to_sym, param)
    BudgetUser.find_by(id: budget_user_id)&.group_id
  end

  def group_id_param
    :budget_user_id
  end

  def update?
    record.owner == user || super
  end

  class Scope < Scope
    def group_base
      group.initiative_expenses
    end

    def resolve
      super(policy.base_index_permission)
    end
  end
end
