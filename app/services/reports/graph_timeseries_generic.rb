class Reports::GraphTimeseriesGeneric
  def initialize(options = {})
    @title = options[:title]
    @data = options[:data]
  end

  def get_header
    [@title]
  end

  def get_body
    @data.map { |data| [to_date(data[0]), data[1]] }
  end

  private

  def to_date(miliseconds)
    DateTime.strptime((miliseconds / 1000).to_s, '%s')
  end
end
