class CheckboxField < Field
  include Optionnable

  def string_value(values)
    return '-' unless values

    values.join(', ')
  end

  def csv_value(values)
    return '' unless values

    values.join(',')
  end

  def serialize_value(value)
    value.present? ? value.to_json : nil
  end

  def deserialize_value(value)
    val = JSON.parse(value || '[]')
    case val
    when Array then val
    else [val]
    end
  end

  def popularity_for_no_option(users)
    nb_users_chose = 0
    users.each do |user|
      user_value = user[self]
      nb_users_chose += 1 if user_value.blank?
    end
    nb_users_chose.to_f / users.size
  end

  def popularity_for_value(value, users)
    nb_users_chose = 0
    users.each do |user|
      user_value = user[self] rescue nil
      nb_users_chose += 1 if user_value && user_value.include?(value)
    end
    nb_users_chose.to_f / users.size
  end

  def user_popularity(user, users)
    values = user[self]

    # If the user didn't select any option, the popularity will be set to the popularity of choosing no option
    if values.blank?
      avg_popularity = popularity_for_no_option(users)
    else
      # Get an array of all the checked options' popularities
      popularities = values.map do |value|
        popularity_for_value(value, users)
      end

      # Get the average popularity
      avg_popularity = popularities.sum / popularities.size
    end

    avg_popularity
  end

  def match_score_between(e1, e2, users)
    e1_popularity = user_popularity(e1, users)
    e2_popularity = user_popularity(e2, users)

    # Returns nil if we don't have all the user info necessary to get a score
    return nil unless e1_popularity && e2_popularity

    # The total score is the absolute difference between both averages
    total_score = (e1_popularity - e2_popularity).abs
  end

  def validates_rule_for_user?(rule:, user:)
    return false if user[rule.field].nil?

    case rule.operator
    when SegmentFieldRule.operators[:contains_any_of]
      (user[rule.field] & rule.values_array).size > 0
    when SegmentFieldRule.operators[:contains_all_of]
      (user[rule.field] & rule.values_array).size == rule.values_array.size
    when SegmentFieldRule.operators[:does_not_contain]
      (user[rule.field] & rule.values_array).size == 0
    end
  end
end
