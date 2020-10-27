class RegionSerializer < ApplicationRecordSerializer
  attributes :id, :permissions

  attributes_with_permission :name, :short_description, :private, if: :family?

  attributes_with_permission :name, :short_description, :description, :parent_id, :private, :home_message, :position,
                             :children, :parent, if: :show?

  def family?
    instance_options[:family]
  end

  def public?
    !object[:private]
  end

  def show?
    policy&.show? && !family?
  end

  # **instance_options

  def children
    object.children.map { |child| GroupSerializer.new(child, **instance_options, family: true).as_json }
  end

  def parent
    object.parent.present? ? GroupSerializer.new(object.parent, scope: scope, family: true) : nil
  end

  def policies
    [
      :create?,
      :show?,
      :destroy?,
      :update?,
    ]
  end
end
