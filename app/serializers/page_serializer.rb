class PageSerializer < ApplicationRecordSerializer
  attributes :total, :type, :items

  def items
    serializer = @instance_options[:use_serializer] |
                 ActiveModel::Serializer.serializer_for(object.items.first)

    object.items.map do |item|
      serializer.new(item, scope: scope, scope_name: :scope).as_json
    end
  end
end
