class Reports::GraphTimeseriesGeneric
  def initialize(options = {})
    @title = options[:title]
    @data = options[:data]
  end

  def get_header
    [@title]
  end

  def get_body
    @data
  end
end
