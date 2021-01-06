class Page < ActiveModelSerializers::Model
  attributes :items, :total, :type, :sum

  def initialize(items, total, sum = nil)
    super({ items: items, total: total, type: items.klass.model_name.singular, sum: sum })
  end

  # Wraps a query in a Page object to match front-end expectations
  def self.of(query)
    new(query, query.unscope(:select).count)
  end
end
