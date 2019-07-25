class SelectField < Field
  include Optionnable

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
      if user.info[self] && user.info[self][0]
        nb_users_answered += 1
        nb_users_chose += 1 if user.info[self][0] === value
      end
    end

    nb_users_chose.to_f / nb_users_answered
  end

  # Get a match score based on two things:
  #   - Community size contrast (a small cluster with a large cluster will be worth more than 2 small clusters)
  #   - Community size (small clusters are worth more)
  def match_score_between(e1, e2, users)
    # Returns nil if we don't have all the user info necessary to get a score
    return nil unless e1.info[self] && e2.info[self]

    e1_value = e1.info[self][0]
    e2_value = e2.info[self][0]

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
    return false if user.info[rule.field].nil?

    field_value = user.info[rule.field][0]

    case rule.operator
    when SegmentRule.operators[:contains_any_of]
      rule.values_array.include?(field_value)
    when SegmentRule.operators[:is_not]
      !rule.values_array.include?(field_value)
    end
  end

  def to_string(data)
    data.join(', ')
  end
end
