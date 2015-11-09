class NumericField < Field
  def string_value(value)
    return "-" if value.nil?
    value
  end

  def serialize_value(value)
    value.to_i
  end

  def match_score_between(e1, e2, employees)
    score = 0
    Benchmark.bm do |x|
      x.report do
        e1_value = e1.info[self]
        e2_value = e2.info[self]

        return nil unless e1_value && e2_value

        values = employees.map do |employee|
          employee.info[self]
        end

        values.compact!

        return nil if values.empty?

        values.reject! { |value| (value - values.mean).abs >= values.standard_deviation*2 } # Reject abberrant values

        high_delta = values.max - values.min

        delta = (e1_value - e2_value).abs

        score = delta.to_f / high_delta
      end
    end

    puts "NUMERIC BENCCCCHMAAARRRRRRKKKKK"
    score
  end

  def validates_rule_for_employee?(rule:, employee:)
    case rule.operator
    when GroupRule.operators[:equals]
      employee.info[rule.field] == rule.values_array[0].to_i
    when GroupRule.operators[:greater_than]
      employee.info[rule.field] > rule.values_array[0].to_i
    when GroupRule.operators[:lesser_than]
      employee.info[rule.field] < rule.values_array[0].to_i
    when GroupRule.operators[:is_not]
      employee.info[rule.field] != rule.values_array[0].to_i
    end
  end

  def stats_in(entries)
    values = entries.map do |entry|
      entry.info[self]
    end

    values.compact!

    {
      min: values.min,
      max: values.max,
      mean: values.mean,
      median: values.median
    }
  end

  def elastic_stats
    # Dynamically calculate bucket sizes
    stats = Employee.search(size: 0, aggs: { global_stats: { stats: { field: "info.#{self.id}" } } }).response

    min = stats[:aggregations][:global_stats][:min]
    max = stats[:aggregations][:global_stats][:max]

    nb_buckets = 5
    delta = max - min
    bucket_size = (delta / nb_buckets).floor

    ranges = []
    nb_buckets.times do |i|
      range = {}

      if i < nb_buckets - 1
        range[:to] = min + (i+1)*bucket_size
      end

      if i > 0
        range[:from] = min + i*bucket_size
      end

      ranges << range
    end

    # Execute the query using the calculated bucket sizes
    Employee.search(
      size: 0,
      aggs: {
        stats: {
          range: {
            field: "info.#{self.id}",
            ranges: ranges
          },
          aggs: {
            stats: {
              stats: { field: "info.#{self.id}" }
            }
          }
        }
      }
    ).response
  end
end
