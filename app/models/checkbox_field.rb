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

  def popularity_for_no_option(employees)
    nb_employees_chose = 0
    employees.each do |employee|
      nb_employees_chose += 1 if employee.info[self].nil?
    end
    nb_employees_chose.to_f / employees.size
  end

  def popularity_for_value(value, employees)
    nb_employees_chose = 0
    employees.each do |employee|
      nb_employees_chose += 1 if employee.info[self] && employee.info[self].include?(value)
    end
    nb_employees_chose.to_f / employees.size
  end

  def employee_popularity(employee, employees)
    values = employee.info[self]

    # If the user didn't select any option, the popularity will be set to the popularity of choosing no option
    if values.nil? || values.empty?
      avg_popularity = popularity_for_no_option(employees)
    else
      # Get an array of all the checked options' popularities
      popularities = values.map do |value|
        popularity_for_value(value, employees)
      end

      # Get the average popularity
      avg_popularity = popularities.sum / popularities.size
    end

    avg_popularity
  end

  def match_score_between(e1, e2, employees)
    e1_popularity = employee_popularity(e1, employees)
    e2_popularity = employee_popularity(e2, employees)

    # Returns nil if we don't have all the employee info necessary to get a score
    return nil unless e1_popularity && e2_popularity

    # The total score is the absolute difference between both averages
    total_score = (e1_popularity - e2_popularity).abs
  end

  def validates_rule_for_employee?(rule:, employee:)
    return false if employee.info[rule.field].nil?

    case rule.operator
    when SegmentRule.operators[:contains_any_of]
      (employee.info[rule.field] & rule.values_array).size > 0
    when SegmentRule.operators[:contains_all_of]
      (employee.info[rule.field] & rule.values_array).size == rule.values_array.size
    when SegmentRule.operators[:does_not_contain]
      (employee.info[rule.field] & rule.values_array).size == 0
    end
  end
end
