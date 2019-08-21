# Custom NumericField
#  - holds a singular numeric value - ie age
class NumericField < Field
  # return list of operator codes for a NumericField
  def operators
    [
      Field::OPERATORS[:equals],
      Field::OPERATORS[:is_not],
      Field::OPERATORS[:greater_than_excl],
      Field::OPERATORS[:lesser_than_excl],
      Field::OPERATORS[:greater_than_incl],
      Field::OPERATORS[:greater_than_incl]
    ]
  end

  # -------------------------------------------------------------------------------------------------
  # TODO: Everything below here is most likely deprecated & needs to be removed
  # DEPRECATED
  # -------------------------------------------------------------------------------------------------

  # @deprecated
  def validates_rule_for_user?(rule:, user:)
    return false if user.info[rule.field].nil?

    case rule.operator
    when SegmentFieldRule.operators[:equals]
      user.info[rule.field] == rule.values_array[0].to_i
    when SegmentFieldRule.operators[:greater_than]
      user.info[rule.field] > rule.values_array[0].to_i
    when SegmentFieldRule.operators[:lesser_than]
      user.info[rule.field] < rule.values_array[0].to_i
    when SegmentFieldRule.operators[:is_not]
      user.info[rule.field] != rule.values_array[0].to_i
    end
  end

  include NumericOptionnable

  def string_value(value)
    return '-' if value.nil?

    value
  end

  def serialize_value(value)
    value.to_i
  end

  def match_score_between(e1, e2, users)
    e1_value = e1.info[self]
    e2_value = e2.info[self]

    return nil unless e1_value && e2_value

    values = users.map do |user|
      user.info[self]
    end

    values.compact!

    return nil if values.empty?

    values.reject! { |value| (value - values.mean).abs >= values.standard_deviation * 2 } # Reject abberrant values

    high_delta = values.max - values.min
    delta = (e1_value - e2_value).abs

    delta.to_f / high_delta
  end


  def stats_in(entries)
    values = entries.map do |entry|
      entry.info[self]
    end

    values.compact!

    {
      min: values.min,
      max: values.max,
      mean: values.mean,
      median: values.median
    }
  end

  def get_buckets_for_range(nb_buckets:, min:, max:)
    delta = max - min
    bucket_size = (delta / nb_buckets).floor

    ranges = []
    nb_buckets.times do |i|
      from = min + i * bucket_size
      to = i == nb_buckets - 1 ? max + 1 : from + bucket_size

      ranges << { from: from, to: to }
    end

    ranges
  end
end
