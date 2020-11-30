class Api::V1::AnnualBudgetsController < DiverstController
  def base
    super.with_expenses
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
