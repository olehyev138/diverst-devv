class GroupWithBudgetSerializer < ActiveModel::Serializer
  attributes :id, :name, :short_description, :description, :parent_id, :enterprise_id,
             :annual_budget, :annual_budget_leftover, :annual_budget_approved, :annual_budget_available
end
