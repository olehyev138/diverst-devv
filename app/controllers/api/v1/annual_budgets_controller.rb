class Api::V1::AnnualBudgetsController < DiverstController
  def base
    super.with_expenses
  end

  def reset_budgets
    base_authorize(klass)

    AnnualBudget.transaction do
      AnnualBudget.reset_budgets(
        amount: params[:amount] || 0,
        init_quarter: to_bool(params[:quarter]),
        type_override: params[:type]&.downcase&.to_sym,
        enterprise_id: current_user.enterprise_id
      )
    end

    head :no_content
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
