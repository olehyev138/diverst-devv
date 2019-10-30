class PageSerializer < ApplicationRecordSerializer
  attributes :total, :type, :items

  has_many :items

  def items
    object.items.map do |item|
      @instance_options[:use_serializer].present? ? @instance_options[:use_serializer].new(item, scope: scope, scope_name: :scope).as_json : item
    end
  end
end
