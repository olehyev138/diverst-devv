class GroupWithBudgetSerializer < ActiveModel::Serializer
  attributes :id, :name, :short_description, :description, :parent_id, :enterprise_id, :logo_location,
  :annual_budget, :unspent, :leftover, :approved, :available

  has_many :children, serializer: GroupWithBudgetSerializer

  def logo_location
    object.logo_location(default_style: instance_options.dig(:scope, :image_size)&.to_sym)
  end
end
