class PageSerializer < ApplicationRecordSerializer
  attributes :total, :type, :items

  def items
    object.items.map do |item|
      (@instance_options[:use_serializer] || "#{item.class}Serializer".constantize).new(item).as_json
    end
  end
end
