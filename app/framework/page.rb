class Page
  include ActiveModel::Serialization

  attr_reader :items
  attr_reader :total

  def initialize(items, total)
    # Serialize the collection of models
    @items = ActiveModelSerializers::SerializableResource.new(items)
    @total = total
  end
end
