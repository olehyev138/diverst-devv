class DateField < Field
  # return list of operator codes for a DateField
  include NumericOptionnable # TODO: MAY BE DEPRECATED
  DEFAULT_DATE_FORMAT = '%F' # TODO: MAY BE DEPRECATED, The ISO 8601 date format (%Y-%m-%d)

  def operators
    [
      Field::OPERATORS[:equals],
      Field::OPERATORS[:is_not],
      Field::OPERATORS[:greater_than_excl],
      Field::OPERATORS[:lesser_than_excl],
      Field::OPERATORS[:greater_than_incl],
      Field::OPERATORS[:lesser_than_incl]
    ]
  end

  # -------------------------------------------------------------------------------------------------
  # TODO: Everything below here is most likely deprecated & needs to be removed
  # DEPRECATED
  # -------------------------------------------------------------------------------------------------

  # @deprecated
  def validates_rule_for_user?(rule:, user:)
    rule_date = Date.parse(rule.values_array[0])
    user_date = user[rule.field]

    case rule.operator
    when SegmentFieldRule.operators[:equals]
      user_date == rule_date
    when SegmentFieldRule.operators[:greater_than]
      user_date > rule_date
    when SegmentFieldRule.operators[:lesser_than]
      user_date < rule_date
    when SegmentFieldRule.operators[:is_not]
      user_date != rule_date
    end
  end

  after_initialize :set_options_array
  attr_accessor :options

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

    case value
    when Time, Date, DateTime then Time.at(value)
    else Time.at(value.to_f)
    end
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
    e1_value = e1[self].strftime('%s').to_i
    e2_value = e2[self].strftime('%s').to_i

    return nil unless e1_value && e2_value

    values = users.map do |user|
      user[self].to_i
    end

    values.compact!
    values.reject! { |value| (value - values.mean).abs >= values.standard_deviation * 2 } # Reject abberrant values
    return nil if values.empty?

    high_delta = values.max - values.min
    return 0 if high_delta == 0 # Lets not divide by zero shall we

    delta = (e1_value - e2_value).abs
    delta.to_f / high_delta
  end

  def get_buckets_for_range(nb_buckets:, min:, max:)
    delta = max - min
    bucket_size = (delta / nb_buckets).floor

    ranges = []
    nb_buckets.times do |i|
      from = min + i * bucket_size
      to = i == nb_buckets - 1 ? max + 1 : from + bucket_size

      ranges << { key: "#{ Time.at(from).strftime('%m/%d/%Y') }-#{ Time.at(to).strftime('%m/%d/%Y') }", from: from, to: to }
    end

    ranges
  end

  def set_options_array
    return self.options = [] if options_text.nil?

    self.options = options_text.lines.map(&:chomp)
  end
end
