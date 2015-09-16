class SelectField < Field
  include Optionnable

  def string_value(value)
    return "-" if value.nil?
    value
  end

  # 0 to 1. 1 being everybody in the business has chosen this option, 0 being nobody chose it
  def popularity_for_value(value, employees)
    puts "------------ POPULARITY START"

    nb_employees_chose = 0

    Benchmark.bm do |x|
      x.report do
        employees.each do |employee|
          nb_employees_chose += 1 if employee.info[self] == value
        end
      end
    end

    puts "------------ POPULARITY END"

    nb_employees_chose.to_f / employees.size
  end

  # Get a match score based on two things:
  #   - Community size contrast (a small cluster with a large cluster will be worth more than 2 small clusters)
  #   - Community size (small clusters are worth more)
  def match_score_between(e1, e2, employees)
    puts "------------------------ SELECT START"
    total_score = 0
    Benchmark.bm do |x|
      x.report do
        e1_value = e1.info[self]
        e2_value = e2.info[self]

        # Returns nil if we don't have all the employee info necessary to get a score
        return nil unless e1_value && e2_value

        e1_popularity = self.popularity_for_value(e1_value, employees)
        e2_popularity = self.popularity_for_value(e2_value, employees)

        if e1_value == e2_value
          popularity_total = e1_popularity
        else
          popularity_total = e1_popularity + e2_popularity
        end

        # Size score
        if e1_value == e2_value
          size_score = 1 - e1_popularity
        else
          size_score = 1 - e1_popularity + e2_popularity
        end

        # Contrast score
        popularity_total = e1_popularity + e2_popularity
        contrast_score = (e1_popularity - e2_popularity).abs / popularity_total

        total_score = (size_score + contrast_score).to_f / 2
      end
    end
    puts "------------------------ SELECT END: #{self.title}"

    total_score
  end

  def validates_rule_for_employee?(rule:, employee:)
    case rule.operator
    when GroupRule.operators[:contains_any_of]
      rule.values[0].include? employee.info[rule.field]
    when GroupRule.operators[:is_not]
      !rule.values[0].include? employee.info[rule.field]
    end
  end
end
