class NumericField < Field
  def string_value(value)
    return '-' if value.nil?
    value
  end

  def serialize_value(value)
    value.to_i
  end

  def match_score_between(e1, e2, users)
    e1_value = e1.info[self]
    e2_value = e2.info[self]

    return nil unless e1_value && e2_value

    values = users.map do |user|
      user.info[self]
    end

    values.compact!

    return nil if values.empty?

    values.reject! { |value| (value - values.mean).abs >= values.standard_deviation * 2 } # Reject abberrant values

    high_delta = values.max - values.min
    delta = (e1_value - e2_value).abs
    score = delta.to_f / high_delta

    score
  end

  def validates_rule_for_user?(rule:, user:)
    return false if user.info[rule.field].nil?

    case rule.operator
    when SegmentRule.operators[:equals]
      user.info[rule.field] == rule.values_array[0].to_i
    when SegmentRule.operators[:greater_than]
      user.info[rule.field] > rule.values_array[0].to_i
    when SegmentRule.operators[:lesser_than]
      user.info[rule.field] < rule.values_array[0].to_i
    when SegmentRule.operators[:is_not]
      user.info[rule.field] != rule.values_array[0].to_i
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

  def get_buckets_for_range(nb_buckets:, min:, max:)
    delta = max - min
    bucket_size = (delta / nb_buckets).floor

    ranges = []
    nb_buckets.times do |i|
      range = {}

      range[:from] = min + i * bucket_size
      range[:to] = range[:from] + bucket_size

      ranges << range
    end

    ranges
  end

  def elastic_stats(aggr_field: nil, segments: container.enterprise.segments.all)
    # Dynamically calculate bucket sizes
    stats = Enterprise.first.search_users(size: 0, aggs: { global_stats: { stats: { field: "combined_info.#{id}" } } })

    min = stats['aggregations']['global_stats']['min']
    max = stats['aggregations']['global_stats']['max']

    buckets = get_buckets_for_range(nb_buckets: 5, min: min, max: max)

    # Craft the aggregation query depending on if we have a field to aggregate on or not
    range_agg = {
      ranges: {
        range: {
          field: "combined_info.#{id}",
          ranges: buckets
        }
      }
    }

    aggs = if aggr_field.nil?
      range_agg
    else
      {
        aggregation: {
          terms: {
            field: "combined_info.#{aggr_field.id}.raw"
          },
          aggs: range_agg
        }
      }
    end

    search_hash = {
      size: 0,
      aggs: aggs
    }

    # Filter the query by segments if there are any specified
    if !segments.nil? && !segments.empty?
      search_hash['query'] = {
        terms: {
          'combined_info.segments' => segments.ids
        }
      }
    end

    # Execute the elasticsearch query
    Enterprise.first.search_users(search_hash)
  end

  def highcharts_stats(aggr_field: nil, segments: container.enterprise.segments.all)
    data = elastic_stats(aggr_field: aggr_field, segments: segments)

    if aggr_field # If there IS an aggregation
      series = data['aggregations']['aggregation']['buckets'].map do |aggr_bucket|
        {
          name: aggr_bucket['key'],
          data: aggr_bucket['ranges']['buckets'].map { |range_bucket| range_bucket['doc_count'] }
        }
      end

      ranges = data['aggregations']['aggregation']['buckets'][0]['ranges']['buckets'].map { |range_bucket| range_bucket['key'].gsub(/\.0/, '') }

      return {
        series: series,
        categories: ranges,
        xAxisTitle: title
      }
    else # If there ISN'T an aggregation
      series = [{
        name: title,
        data: data['aggregations']['ranges']['buckets'].map { |range_bucket| range_bucket['doc_count'] }
      }]

      ranges = data['aggregations']['ranges']['buckets'].map { |range_bucket| range_bucket['key'].gsub(/\.0/, '') }

      return {
        series: series,
        categories: ranges,
        xAxisTitle: title
      }
    end
  end
end
