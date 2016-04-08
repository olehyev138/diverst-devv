module Optionnable
  extend ActiveSupport::Concern

  included do
    after_initialize :set_options_array
    attr_accessor :options
  end

  def serialize_value(value)
    Array(value)
  end

  def answer_popularities(entries:)
    answer_counts = {}

    options.each do |option|
      answer_counts[option] = 0
    end

    entries.each do |entry|
      values = entry.info[self]

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

  def elastic_stats(aggr_field: nil, segments: container.enterprise.segments.all)
    # Craft the aggregation query depending on if we have a field to aggregate on or not
    aggs = if aggr_field.nil?
      es_term_aggregation
    else
     {
       aggregation: {
          terms: {
            field: aggr_field.elasticsearch_field,
            min_doc_count: 0
          },
          aggs: es_term_aggregation
        }
      }
    end

    execute_elasticsearch_query(
      index: container.enterprise.es_users_index_name,
      segments: segments,
      search_hash: {
        aggs: aggs
      }
    )
  end

  def elastic_timeseries(segments: container.enterprise.segments.all)
    aggs = es_term_aggregation(
      aggs: {
        date_histogram: {
          date_histogram: {
            field: 'created_at',
            interval: '1d',
            min_doc_count: 1
          }
        }
      },
      sample: true
    )

    execute_elasticsearch_query(
      index: container.enterprise.es_samples_index_name,
      segments: segments,
      search_hash: {
        aggs: aggs
      }
    )
  end

  def es_term_aggregation(aggs: nil, sample: false)
    term_query = {
      terms: {
        terms: {
          field: sample ? elasticsearch_sample_field : elasticsearch_field,
          min_doc_count: 0
        }
      }
    }

    term_query[:terms][:aggs] = aggs unless aggs.nil?

    term_query
  end

  def execute_elasticsearch_query(segments:, search_hash:, index:)
    # Filter the query by segments if there are any specified
    if !segments.nil? && !segments.empty?
      search_hash['query'] = {
        terms: {
          'combined_info.segments' => segments.ids
        }
      }
    end

    # Execute the elasticsearch query
    Elasticsearch::Model.client.search(
      index: index,
      body: search_hash,
      search_type: 'count'
    )
  end

  # Get highcharts-usable stats from the field by querying elasticsearch and formatting its response
  def highcharts_stats(aggr_field: nil, segments: container.enterprise.segments.all)
    data = elastic_stats(aggr_field: aggr_field, segments: segments)

    if aggr_field # If there is an aggregation
      at_least_one_bucket_has_other = false

      options = data['aggregations']['aggregation']['buckets'].map { |aggr_bucket|
        aggr_bucket['terms']['buckets'].map do |option_bucket|
          option_bucket['key']
        end
      }.flatten.uniq

      series = data['aggregations']['aggregation']['buckets'].map do |aggr_bucket|
        bucket_data = options.map do |option|
          bucket = aggr_bucket['terms']['buckets'].find { |b| b['key'] == option }

          if bucket
            bucket['doc_count']
          else
            0
          end
        end

        other_docs_count = aggr_bucket['terms']['sum_other_doc_count']

        if other_docs_count > 0
          bucket_data << other_docs_count
          at_least_one_bucket_has_other = true
        end

        {
          name: aggr_bucket['key'],
          data: bucket_data
        }
      end

      options << 'Other' if at_least_one_bucket_has_other

      sum_other_doc_count = data['aggregations']['aggregation']['sum_other_doc_count']

      # Handle 'Other' bucket
      if sum_other_doc_count > 0
        # Fetch all the missing buckets (exclude the ones that were already fetched)
        must_nots = []

        series.each do |serie|
          must_nots << {
            term: {
              aggr_field.elasticsearch_field.to_s => serie['name']
            }
          }
        end

        others_hash = {
          size: 0,
          query: {
            filtered: {
              filter: {
                bool: {
                  must_not: must_nots
                }
              }
            }
          },
          aggs: {
            aggregation: {
              terms: {
                field: elasticsearch_field,
                min_doc_count: 0,
                order: {
                  '_term' => 'asc'
                }
              }
            }
          }
        }

        others = Elasticsearch::Model.client.search(
          index: container.enterprise.es_users_index_name,
          body: others_hash,
          search_type: 'count'
        )

        others_data = options.map do |option|
          bucket = others['aggregations']['aggregation']['buckets'].find { |b| b['key'] == option }

          if bucket
            bucket['doc_count']
          else
            0
          end
        end

        series << { name: 'Other', data: others_data }
      end

      return {
        series: series,
        categories: options.map { |o| format_value_name(o) },
        xAxisTitle: title
      }
    else # If there is no aggregation
      buckets = data['aggregations']['terms']['buckets']
      other_docs_count = data['aggregations']['terms']['sum_other_doc_count']

      seriesData = buckets.map do |option_bucket|
        {
          name: format_value_name(option_bucket['key']),
          y: option_bucket['doc_count']
        }
      end

      seriesData << { name: 'Other', y: other_docs_count } if other_docs_count > 0

      {
        name: title,
        data: seriesData
      }
    end
  end

  def highcharts_timeseries(segments:)
    data = elastic_timeseries(segments: segments)

    ap data

    series = data['aggregations']['terms']['buckets'].map do |term_bucket|
      time_buckets = term_bucket['date_histogram']['buckets']
      other_docs_count = term_bucket['date_histogram']['sum_other_doc_count']

      term_data = time_buckets.map do |time_bucket|
        [
          time_bucket['key'],
          time_bucket['doc_count']
        ]
      end

      {
        name: format_value_name(term_bucket['key']),
        data: term_data
      }
    end
  end

  def elasticsearch_field
    "combined_info.#{id}.raw"
  end

  def elasticsearch_sample_field
    "info.#{id}.raw"
  end

  protected

  def set_options_array
    return self.options = [] if options_text.nil?
    self.options = options_text.lines.map(&:chomp)
  end
end
