class DateField < Field
  def string_value(value)
    return "-" if value.nil?
    value.to_s :slashes
  end

  def process_field_value(value)
    Time.strptime("10/15/2013", "%m/%d/%Y")
  end

  def deserialize_value(value)
    Time.at(value)
  end

  def serialize_value(value)
    return nil if value.empty?
    value.strftime("%s").to_i
  end

  def match_score_between(e1, e2, employees)
    score = 0
    Benchmark.bm do |x|
      x.report do
        e1_value = e1.info[self].strftime("%s").to_i
        e2_value = e2.info[self].strftime("%s").to_i

        return score = nil unless e1_value && e2_value

        values = employees.map do |employee|
          employee.info[self].to_i
        end

        values.compact!
        values.reject! { |value| (value - values.mean).abs >= values.standard_deviation*2 } # Reject abberrant values
        return score = nil if values.empty?

        high_delta = values.max - values.min
        return score = 0 if high_delta == 0 # Lets not divide by zero shall we
        delta = (e1_value - e2_value).abs
        score = delta.to_f / high_delta
      end
    end

    puts "DATE BENCCCCHMAAARRRRRRKKKKK"
    score
  end

  def validates_rule_for_employee?(rule:, employee:)
    case rule.operator
    when GroupRule.operators[:equals]
      employee.info[rule.field] == rule.values[0].to_i
    when GroupRule.operators[:greater_than]
      employee.info[rule.field] > rule.values[0].to_i
    when GroupRule.operators[:lesser_than]
      employee.info[rule.field] < rule.values[0].to_i
    when GroupRule.operators[:is_not]
      employee.info[rule.field] != rule.values[0].to_i
    end
  end
end
