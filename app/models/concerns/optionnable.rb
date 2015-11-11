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

  def elastic_stats(aggr_field: nil)
    # Craft the aggregation query depending on if we have a field to aggregate on or not
    term_agg = {
      terms: {
        terms: {
          field: "info.#{self.id}.raw"
        }
      }
    }

    if aggr_field.nil?
      aggs = term_agg
    else
      aggs = {
        aggregation: {
          terms: {
            field: "info.#{aggr_field.id}.raw"
          },
          aggs: term_agg
        }
      }
    end

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
          name: aggr_bucket[:key],
          data: aggr_bucket[:terms][:buckets].map{ |option_bucket| option_bucket[:doc_count] }
        }
      end

      options = data[:aggregations][:aggregation][:buckets][0][:terms][:buckets].map{ |option_bucket| option_bucket[:key].gsub(/\.0/, '') }

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