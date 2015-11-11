class SelectField < Field
  include Optionnable

  def string_value(value)
    return "-" if value.nil? || value.empty?
    value[0]
  end

  # 0 to 1. 1 being everybody in the business has chosen this option, 0 being nobody chose it
  def popularity_for_value(value, employees)
    puts "------------ POPULARITY START"

    nb_employees_chose = 0

    Benchmark.bm do |x|
      x.report do
        employees.each do |employee|
          nb_employees_chose += 1 if employee.info[self][0] == value
        end
      end
    end

    puts "------------ POPULARITY END"

    nb_employees_chose.to_f / employees.size
  end

  # Get a match score based on two things:
  #   - Community size contrast (a small cluster with a large cluster will be worth more than 2 small clusters)
  #   - Community size (small clusters are worth more)
  def match_score_between(e1, e2, employees)
    puts "------------------------ SELECT START"
    total_score = 0
    Benchmark.bm do |x|
      x.report do
        # Returns nil if we don't have all the employee info necessary to get a score
        return nil unless e1.info[self] && e2.info[self]

        e1_value = e1.info[self][0]
        e2_value = e2.info[self][0]

        e1_popularity = self.popularity_for_value(e1_value, employees)
        e2_popularity = self.popularity_for_value(e2_value, employees)

        if e1_value == e2_value
          popularity_total = e1_popularity
        else
          popularity_total = e1_popularity + e2_popularity
        end

        # Size score
        if e1_value == e2_value
          size_score = 1 - e1_popularity
        else
          size_score = 1 - e1_popularity + e2_popularity
        end

        # Contrast score
        popularity_total = e1_popularity + e2_popularity
        contrast_score = (e1_popularity - e2_popularity).abs / popularity_total

        total_score = (size_score + contrast_score).to_f / 2
      end
    end
    puts "------------------------ SELECT END: #{self.title}"

    total_score
  end

  def validates_rule_for_employee?(rule:, employee:)
    case rule.operator
    when SegmentRule.operators[:contains_any_of]
      rule.values_array.include?(employee.info[rule.field][0])
    when SegmentRule.operators[:is_not]
      !rule.values_array.include?(employee.info[rule.field][0])
    end
  end

  def elastic_stats
    Employee.search(
      size: 0,
      aggs: {
        sums: {
          terms: {
            field: "info.#{self.id}"
          }
        }
      }
    ).response
  end

  def highcharts_data(aggr_field: nil)
    data = elastic_stats(aggr_field: aggr_field)

    if aggr_field # If there is an aggregation
      # series = data[:aggregations][:aggregation][:buckets].map do |aggr_bucket|
      #   {
      #     name: aggr_bucket[:key],
      #     data: aggr_bucket[:ranges][:buckets].map{ |range_bucket| range_bucket[:doc_count] }
      #   }
      # end

      # ranges = data[:aggregations][:aggregation][:buckets][0][:ranges][:buckets].map{ |range_bucket| range_bucket[:key].gsub(/\.0/, '') }

      # return {
      #   series: series,
      #   ranges: ranges,
      #   xAxisTitle: self.title
      # }
    else # If there is no aggregation
      ranges = data[:aggregations][:ranges][:buckets].map{ |bucket| bucket[:key] }
      values = data[:aggregations][:ranges][:buckets].map{ |bucket| bucket[:doc_count] }

      seriesData = data[:aggregations][:ranges][:buckets].map do |range_bucket|
        {
          name: range_bucket[:key],
          y: range_bucket[:doc_count]
        }
      end

      return {
        fieldTitle: self.title,
        seriesData: seriesData
      }
    end
  end
end
