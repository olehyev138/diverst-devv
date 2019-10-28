class PageSerializer < ApplicationRecordSerializer
  attributes :total, :type, :items

  has_many :items

  def items
    object.items.map do |item|
      @instance_options[:use_serializer] ? @instance_options[:use_serializer].new(item).as_json : item
    end
  end
end
