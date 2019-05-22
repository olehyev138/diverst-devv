module Metrics
  module MetricsUtil
    def parse_date_range(date_range)
      # Parse a date range from a frontend range_controller for a es date range aggregation
      # Date range is {} or looks like { from: <>, to: <> }, with to being optional

      default_from_date = 'now-200y/y'
      default_to_date = DateTime.tomorrow.strftime('%F')

      return { from: default_from_date, to: default_to_date } if date_range.blank?

      from_date = date_range[:from_date].presence || default_from_date
      to_date = DateTime.parse((date_range[:to_date].presence || default_to_date)).strftime('%F')

      from_date = case from_date
                  when '1m'     then 'now-1M'
                  when '3m'     then 'now-3M'
                  when '6m'     then 'now-6M'
                  when 'ytd'    then Time.now.beginning_of_year.strftime('%F')
                  when '1y'     then 'now-1y'
                  when 'all'    then 'now-200y'
                  else
                    DateTime.parse(from_date).strftime('%F')
      end

      { from: from_date, to: to_date }
    end

    def add_scoped_model_filter(graph_builder, field, scoped_ids)
      # Wraps an existing ElasticsearchQuery in a filter that filters on a list of model ids
      return graph_builder.query if scoped_ids.blank?

      query = graph_builder.get_new_query.bool_filter_agg { |_| graph_builder.query }
      query.add_filter_clause(field: field, value: scoped_ids, bool_op: :must, multi: true)

      query
    end

    def get_change_percentage(from_date_total, to_date_total)
      if (from_date_total == 0) && (to_date_total > 0)
        change_percentage = 100
      elsif (to_date_total == 0) && (from_date_total > 0)
        change_percentage = -100
      elsif (from_date_total == 0) && (to_date_total == 0)
        change_percentage = 0
      else
        change_percentage =
          ((((to_date_total - from_date_total) / from_date_total)) * 100).round(2)
      end

      if change_percentage.positive?
        ('+' + (change_percentage.to_s)) + '%'
      else
        change_percentage.to_s + '%'
      end
    end

    def c_t(key)
      enterprise.custom_text.send(key)
    end

    def enterprise
      Enterprise.find(self.enterprise_id)
    end

    def enterprise_id
      self.enterprise_id
    end
  end
end
