class Reports::GraphGeneric < Reports::GraphStats
  def initialize(options = {})
    @title = options[:title]
    @categories = options[:categories]
    @data = options[:data]
  end

  def get_header
    [@title]
  end

  def get_body
    @categories.zip @data
  end
end
