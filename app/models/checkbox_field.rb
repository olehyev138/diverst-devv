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

  def popularity_for_no_option(users)
    nb_users_chose = 0
    users.each do |user|
      nb_users_chose += 1 if user.info[self].nil?
    end
    nb_users_chose.to_f / users.size
  end

  def popularity_for_value(value, users)
    nb_users_chose = 0
    users.each do |user|
      nb_users_chose += 1 if user.info[self] && user.info[self].include?(value)
    end
    nb_users_chose.to_f / users.size
  end

  def user_popularity(user, users)
    values = user.info[self]

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
    return false if user.info[rule.field].nil?

    case rule.operator
    when SegmentRule.operators[:contains_any_of]
      (user.info[rule.field] & rule.values_array).size > 0
    when SegmentRule.operators[:contains_all_of]
      (user.info[rule.field] & rule.values_array).size == rule.values_array.size
    when SegmentRule.operators[:does_not_contain]
      (user.info[rule.field] & rule.values_array).size == 0
    end
  end

  def to_string(data)
    data.join(', ')
  end
end
