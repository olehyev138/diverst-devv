class GroupWithBudgetSerializer < ApplicationRecordSerializer
  attributes :id, :name, :short_description, :description, :parent_id, :enterprise_id,
             :annual_budget, :annual_budget_leftover, :annual_budget_approved, :annual_budget_available, :permissions

  def policies
    [
        :annual_budgets_manage?,
        :carryover_annual_budget?,
        :reset_annual_budget?,
    ]
  end
end
