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

  def elastic_stats(aggr_field: nil, target_segment_ids: nil)
    # Craft the aggregation query depending on if we have a field to aggregate on or not
    term_agg = {
      terms: {
        terms: {
          field: "info.#{self.id}.raw",
          min_doc_count: 0
        }
      }
    }

    if aggr_field.nil?
      aggs = term_agg
    else
      aggs = {
        aggregation: {
          terms: {
            field: "info.#{aggr_field.id}.raw",
            min_doc_count: 0
          },
          aggs: term_agg
        }
      }
    end

    search_hash = {
      size: 0,
      aggs: aggs
    }

    # Filter the query by segments if there are any specified
    if !target_segment_ids.nil? && !target_segment_ids.empty?
      search_hash[:query] = {
        terms: {
          id: Employee.joins(:segments).where("segments.id" => target_segment_ids).ids
        }
      }
    end

    # Execute the elasticsearch query
    Employee.search(search_hash).response
  end

  def highcharts_data(aggr_field: nil, target_segment_ids: nil)
    data = elastic_stats(aggr_field: aggr_field, target_segment_ids: target_segment_ids)

    if aggr_field # If there is an aggregation
      terms_has_other = false

      series = data[:aggregations][:aggregation][:buckets].map do |aggr_bucket|
        bucket_data = aggr_bucket[:terms][:buckets].map do |option_bucket|
          option_bucket[:doc_count]
        end

        other_docs_count = aggr_bucket[:terms][:sum_other_doc_count]

        if other_docs_count > 0
          bucket_data << other_docs_count
          terms_has_other = true
        end

        {
          name: aggr_bucket[:key],
          data: bucket_data
        }
      end

      options = data[:aggregations][:aggregation][:buckets][0][:terms][:buckets].map{ |option_bucket| option_bucket[:key].gsub(/\.0/, '') }

      options << "Other" if terms_has_other

      aggr_other_docs_count = data[:aggregations][:aggregation][:sum_other_doc_count]
      series << { name: "Other", data: [aggr_other_docs_count]} if aggr_other_docs_count > 0

      return {
        series: series,
        categories: options,
        xAxisTitle: self.title
      }
    else # If there is no aggregation
      seriesData = data[:aggregations][:terms][:buckets].map do |option_bucket|
        {
          name: option_bucket[:key],
          y: option_bucket[:doc_count]
        }
      end

      other_docs_count = data[:aggregations][:terms][:sum_other_doc_count]
      seriesData << { name: "Other", y: other_docs_count} if other_docs_count > 0

      series = [{
        name: self.title,
        data: seriesData
      }]

      return {
        series: series
      }
    end
  end

  protected

  def set_options_array
    return self.options = [] if self.options_text.nil?
    self.options = self.options_text.lines.map(&:chomp)
  end
end