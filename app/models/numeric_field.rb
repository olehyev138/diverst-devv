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
end
