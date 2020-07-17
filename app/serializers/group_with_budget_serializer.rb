class GroupWithBudgetSerializer < ApplicationRecordSerializer
  attributes :id, :name, :short_description, :description, :parent_id, :enterprise_id, :currency, :children,
             :annual_budget, :annual_budget_leftover, :annual_budget_approved, :annual_budget_available, :permissions

  def children
    if instance_options[:with_children]
      object.children.map do |child|
        GroupWithBudgetSerializer.new(child, **instance_options, family: true).as_json
      end
    end
  end

  def currency
    object.annual_budget_currency
  end

  def policies
    [
        :annual_budgets_manage?,
        :carryover_annual_budget?,
        :reset_annual_budget?,
    ]
  end
end
