class DateField < Field
  include Optionnable

  DEFAULT_DATE_FORMAT = '%F' # The ISO 8601 date format (%Y-%m-%d)

  def string_value(value)
    return '-' if value.nil?
    value.to_s :slashes
  end

  def process_field_value(value)
    Time.strptime(value, '%F')
  rescue
    nil
  end

  def deserialize_value(value)
    return nil if value.nil?
    Time.at(value)
  end

  def serialize_value(value)
    return nil if value.nil?
    value.strftime('%s').to_i
  end

  def csv_value(value)
    return '' if value.nil?
    value.strftime('%F')
  end

  def match_score_between(e1, e2, users)
    e1_value = e1.info[self].strftime('%s').to_i
    e2_value = e2.info[self].strftime('%s').to_i

    return nil unless e1_value && e2_value

    values = users.map do |user|
      user.info[self].to_i
    end

    values.compact!
    values.reject! { |value| (value - values.mean).abs >= values.standard_deviation * 2 } # Reject abberrant values
    return nil if values.empty?

    high_delta = values.max - values.min
    return 0 if high_delta == 0 # Lets not divide by zero shall we
    delta = (e1_value - e2_value).abs
    delta.to_f / high_delta
  end

  def validates_rule_for_user?(rule:, user:)
    rule_date = Date.parse(rule.values_array[0])
    user_date = user.info[rule.field]

    case rule.operator
    when SegmentRule.operators[:equals]
      user_date == rule_date
    when SegmentRule.operators[:greater_than]
      user_date > rule_date
    when SegmentRule.operators[:lesser_than]
      user_date < rule_date
    when SegmentRule.operators[:is_not]
      user_date != rule_date
    end
  end
end
