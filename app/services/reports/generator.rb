class Reports::Generator
  def initialize(strategy_generator)
    @strategy_generator = strategy_generator
  end

  def to_csv
    CSV.generate do |csv|
      @strategy_generator.get_header.map { |row| csv << row }
      @strategy_generator.get_body.map { |row| csv << row }
    end
  end
end
