class CheckboxField < Field
  include Optionnable

  def serialize_value(value)
    Array(value)
  end

  def string_value(value)
    return "-" if !value
    value.join(', ')
  end

  def popularity_for_no_option
    nb_employees_chose = 0
    self.enterprise.employees.each do |employee|
      nb_employees_chose += 1 if employee.info[self].nil?
    end
    nb_employees_chose.to_f / self.enterprise.employees.count
  end

  def popularity_for_value(value)
    nb_employees_chose = 0
    self.enterprise.employees.each do |employee|
      nb_employees_chose += 1 if employee.info[self] && employee.info[self].include?(value)
    end
    nb_employees_chose.to_f / self.enterprise.employees.count
  end

  def employee_popularity(employee)
    values = employee.info[self]

    # If the user didn't select any option, the popularity will be set to the popularity of choosing no option
    if values.nil?
      avg_popularity = self.popularity_for_no_option
    else
      # Get an array of all the checked options' popularities
      popularities = values.map do |value|
        self.popularity_for_value(value)
      end

      # Get the average popularity
      avg_popularity = popularities.sum / popularities.size
    end
  end

  def match_score_between(e1, e2)
    e1_popularity = self.employee_popularity(e1)
    e2_popularity = self.employee_popularity(e2)

    # Returns nil if we don't have all the employee info necessary to get a score
    return nil unless e1_popularity && e2_popularity

    # The total score is the absolute difference between both averages
    total_score = (e1_popularity - e2_popularity).abs
  end
end