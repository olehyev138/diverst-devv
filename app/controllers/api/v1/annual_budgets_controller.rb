class Api::V1::AnnualBudgetsController < DiverstController
  def base
    super.with_expenses
  end

  def reset_budgets
    base_authorize(klass)

    override = if params.key?(:period_override)
      params[:period_override].presence || [nil, nil]
    else
      nil
    end
    new_period = [nil, nil]

    AnnualBudget.transaction do
      new_period = AnnualBudget.reset_budgets(
        amount: params[:amount] || 0,
        init_quarter: to_bool(params[:init_quarter]),
        type_override: params[:type]&.downcase&.to_sym,
        period_override: override,
        enterprise_id: current_user.enterprise_id
      )
    end

    render status: 200, json: new_period
  end

  private

  def model_map(model)
    model.group
  end

  def action_map(action)
    case action
    when :update then 'annual_budget_update'
    else nil
    end
  end
end
