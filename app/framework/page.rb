class Page
  
  include ActiveModel::Serialization
  
  attr_reader :items
  attr_reader :total
  
  def initialize(items, total)
    @items = items
    @total = total
  end
  
end