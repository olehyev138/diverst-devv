class PageSerializer < ApplicationRecordSerializer
  attributes :total, :type, :items

  # has_many :items, each_serializer: @instance_options[:use_serializer]
  def items
    object.items.map do |item|
      (@instance_options[:use_serializer] || "#{item.class}Serializer".constantize).new(item).as_json
    end
  end
end
