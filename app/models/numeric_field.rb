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

  def elastic_stats(aggr_field: nil)
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

      range[:from] = min + i*bucket_size
      range[:to] = range[:from] + bucket_size

      ranges << range
    end

    # Craft the aggregation query depending on if we have a field to aggregate on or not
    range_agg = {
      ranges: {
        range: {
          field: "info.#{self.id}",
          ranges: ranges
        }
      }
    }

    if aggr_field.nil?
      aggs = range_agg
    else
      aggs = {
        aggregation: {
          terms: {
            field: "info.#{aggr_field.id}.raw"
          },
          aggs: range_agg
        }
      }
    end

    # Execute the Elasticsearch query
    Employee.search(
      size: 0,
      aggs: aggs
    ).response
  end

  def highcharts_data(aggr_field: nil)
    data = elastic_stats(aggr_field: aggr_field)

    if aggr_field # If there is an aggregation
      series = data[:aggregations][:aggregation][:buckets].map do |aggr_bucket|
        {
          name: "#{aggr_bucket[:key]}",
          data: aggr_bucket[:ranges][:buckets].map{ |range_bucket| range_bucket[:doc_count] }
        }
      end

      pp data

      ranges = data[:aggregations][:aggregation][:buckets][0][:ranges][:buckets].map{ |range_bucket| range_bucket[:key].gsub(/\.0/, '') }

      return {
        series: series,
        categories: ranges,
        xAxisTitle: self.title
      }
    else # If there is no aggregation
      series = [{
        name: self.title,
        data: data[:aggregations][:ranges][:buckets].map{ |range_bucket| range_bucket[:doc_count] }
      }]

      ranges = data[:aggregations][:ranges][:buckets].map{ |range_bucket| range_bucket[:key].gsub(/\.0/, '') }

      return {
        series: series,
        categories: ranges,
        xAxisTitle: self.title
      }
    end
  end
end
