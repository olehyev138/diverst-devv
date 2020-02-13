module NumericOptionnable
  extend ActiveSupport::Concern

  def elasticsearch_field
    "combined_info.#{id}.raw"
  end

  def answer_popularities(entries:)
    answer_counts = {}

    options.each do |option|
      answer_counts[option] = 0
    end

    entries.each do |entry|
      values = entry[self]

      values.each do |value|
        if answer_counts[value]
          answer_counts[value] += 1
        else
          answer_counts[value] = 0
        end
      end
    end

    # Export a better formatted version
    answer_counts_formatted = []
    answer_counts.each do |answer, count|
      answer_counts_formatted << {
        answer: answer,
        count: count
      }
    end

    answer_counts_formatted
  end

  def elastic_stats(segments:, groups:)
    # Dynamically calculate bucket sizes
    stats = enterprise.search_users(size: 0, aggs: { global_stats: { stats: { field: "combined_info.#{id}" } } })

    min = stats['aggregations']['global_stats']['min'] || 0
    max = stats['aggregations']['global_stats']['max'] || 0

    buckets = get_buckets_for_range(nb_buckets: 5, min: min, max: max)

    # Craft the aggregation query depending on if we have a field to aggregate on or not
    aggs = {
      ranges: {
        range: {
          field: "combined_info.#{id}",
          ranges: buckets
        }
      }
    }

    search_hash = {
      size: 0,
      aggs: aggs
    }

    # Filter the query by segments if there are any specified
    terms = []
    if segments.present?
      terms << {
        terms: {
          'combined_info.segments' => segments.ids
        }
      }
    end

    if groups.present?
      terms << {
        terms: {
          'combined_info.groups' => groups.ids
        }
      }
    end

    search_hash['query'] = { filtered: { filter: { bool: { should: terms } } } }

    # Execute the elasticsearch query
    enterprise.search_users(search_hash)
  end

  def highcharts_stats(aggr_field: nil, segments: [], groups: [])
    data = elastic_stats(segments: segments, groups: groups)

    series = [{
      name: title,
      data: data['aggregations']['ranges']['buckets'].map { |range_bucket| range_bucket['doc_count'] }
    }]

    ranges = data['aggregations']['ranges']['buckets'].map { |range_bucket| range_bucket['key'].gsub(/\.0/, '') }

    {
      series: series,
      categories: ranges,
      xAxisTitle: title
    }
  end
end
