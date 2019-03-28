class Reports::Generator
  def initialize(strategy_generator)
    @strategy_generator = strategy_generator
  end

  def to_csv
    CSV.generate do |csv|
      if @strategy_generator.class == Reports::GraphStats
        @strategy_generator.get_header.map { |row| csv << row }
      else
        csv << @strategy_generator.get_header
      end

      @strategy_generator.get_body.map { |row| csv << row }
    end
  end
end
