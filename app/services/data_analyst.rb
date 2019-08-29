class DataAnalyst
  def self.calculate_aggregate_data(sample)
    Rails.cache.fetch("calculate_aggregate_data/#{sample}") do
      max = sample.max_by { |x| x[1] }
      n = sample.count
      sum = sample.sum { |x| x[1] }
      mean = sum.to_f / n
      sd = Math.sqrt(sample.reduce(0) { |partial, element| partial + (element[1] - mean)**2 / n })
      return sum, max[0], max[1], mean.round(2), sd.round(2)
    end
  end

  def self.calculate_percentile(number, sample)
    Rails.cache.fetch("calculate_percentile/#{number}, #{sample}") do
      n = sample.count
      i = sample.each_index.select { |r| sample[r] <= number }.last
      101 - (100 * ((i + 1) - 0.5) / n).round
    end
  end

  def self.aggregate_data_from_field(model, *fields, where: [nil], enterprise_id: nil)
    list_of_values = model.cached_count_list(*fields, where: where, enterprise_id: enterprise_id)
    calculate_aggregate_data(list_of_values)
  end

  def self.percentile_from_field(model, number, *fields, where: [nil], enterprise_id: nil)
    list_of_values = model.cached_count_list(*fields, where: where, enterprise_id: enterprise_id)
    calculate_percentile(number, list_of_values.map { |count| count[1] }.sort)
  end
end
