class Page < ActiveModelSerializers::Model
  attributes :items, :total, :type

  def initialize(items, total)
    super({ items: items, total: total, type: items.klass.name.downcase })
  end
end
