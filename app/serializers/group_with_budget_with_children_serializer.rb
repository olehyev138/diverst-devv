class GroupWithBudgetSerializer < ActiveModel::Serializer
  attributes :id, :name, :short_description, :description, :parent_id, :enterprise_id,
             :annual_budget, :annual_budget_leftover, :annual_budget_approved, :annual_budget_available

  has_many :children, serializer: GroupWithBudgetSerializer

  def logo_location
    object.logo_location(default_style: instance_options.dig(:scope, :image_size)&.to_sym)
  end
end
