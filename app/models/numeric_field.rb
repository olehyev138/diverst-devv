class NumericField < Field
  def string_value(value)
    return "-" if value.nil?
    value
  end

  def serialize_value(value)
    value.to_i
  end

  def match_score_between(e1, e2)
    return nil unless e1.enterprise == e2.enterprise

    e1_value = e1.info[self]
    e2_value = e2.info[self]

    return nil unless e1_value && e2_value

    values = e1.enterprise.employees.all.map do |employee|
      employee.info[self]
    end

    max_delta = values.max - values.min

    delta = (e1_value - e2_value).abs

    delta.to_f / max_delta
  end
end
