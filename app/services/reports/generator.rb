class Reports::Generator
  def initialize(strategy_generator)
    @strategy_generator = strategy_generator
  end

  def to_csv
    CSV.generate do |csv|
      csv << @strategy_generator.get_header
      @strategy_generator.get_body.map{ |data| csv << data }
    end
  end
end
