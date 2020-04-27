class PageSerializer < ApplicationRecordSerializer
  attributes :total, :type, :sum, :items

  def items
    object.items.load unless object.items.kind_of?(Array) || object.items.loaded?
    serializer = @instance_options[:use_serializer] ||
                 ActiveModel::Serializer.serializer_for(object.items.first)

    object.items.map do |item|
      serializer.new(item, @instance_options).as_json
    end
  end
end
