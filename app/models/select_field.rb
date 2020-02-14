# Custom SelectField
#  - holds a *singular* value - non multi
#  - CheckboxField is a multi select
class SelectField < Field
  # return list of operator codes for a SelectField
  include Optionnable # TODO: MAY BE DEPRECATED

  def operators
    [
      Field::OPERATORS[:equals_any_of],
      Field::OPERATORS[:not_equals_any_of]
    ]
  end

  def evaluate(v1, v2, operator)
    case operator
    when OPERATORS[:equals_any_of]
      v2.is_a?(Array) && (v2.include? v1[0])
    when OPERATORS[:not_equals_any_of]
      v2.is_a?(Array) && (v2.exclude? v1[0])
    else
      super(v1, v2, operators)
    end
  end

  def serialize_value(value)
    case value
    when String then [value].to_json
    when Array then value.to_json
    else nil
    end
  end

  def deserialize_value(value)
    JSON.parse(value || '[]')
  end

  # -------------------------------------------------------------------------------------------------
  # TODO: Everything below here is most likely deprecated & needs to be removed
  # DEPRECATED
  # -------------------------------------------------------------------------------------------------

  def string_value(value)
    return '-' if value.blank?

    value[0]
  end

  def csv_value(value)
    return '' if value.blank?

    value[0]
  end

  # 0 to 1. 1 being everybody in the business has chosen this option, 0 being nobody chose it
  def popularity_for_value(value, users)
    nb_users_chose = 0
    nb_users_answered = 0

    users.each do |user|
      if user[self] && user[self][0]
        nb_users_answered += 1
        nb_users_chose += 1 if user[self][0] === value
      end
    end

    nb_users_chose.to_f / nb_users_answered
  end

  # Get a match score based on two things:
  #   - Community size contrast (a small cluster with a large cluster will be worth more than 2 small clusters)
  #   - Community size (small clusters are worth more)
  def match_score_between(e1, e2, users)
    e1_value = e1[self][0]
    e2_value = e2[self][0]

    # Returns nil if we don't have all the user info necessary to get a score
    return nil unless e1_value && e2_value

    e1_popularity = popularity_for_value(e1_value, users)
    e2_popularity = popularity_for_value(e2_value, users)

    # Size score
    size_score = if e1_value == e2_value
      1 - e1_popularity
    else
      1 - e1_popularity + e2_popularity
    end

    # Contrast score
    popularity_total = if e1_value == e2_value
      e1_popularity
    else
      e1_popularity + e2_popularity
    end

    contrast_score = (e1_popularity - e2_popularity).abs / popularity_total

    # Total score
    (size_score + contrast_score).to_f / 2
  end

  def validates_rule_for_user?(rule:, user:)
    return false if user[rule.field].nil?

    field_value = user[rule.field][0]

    case rule.operator
    when SegmentFieldRule.operators[:contains_any_of]
      rule.values_array.include?(field_value)
    when SegmentFieldRule.operators[:is_not]
      !rule.values_array.include?(field_value)
    end
  end
end
