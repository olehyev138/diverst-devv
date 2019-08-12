class TextField < Field
  def validates_rule_for_user?(rule:, user:)
    case rule.operator
    when SegmentFieldRule.operators[:equals]
      user.info[rule.field] == rule.values_array[0]
    when SegmentFieldRule.operators[:contains_any_of]
      user.info[rule.field].include? rule.values_array[0]
    when SegmentFieldRule.operators[:does_not_contain]
      !user.info[rule.field].include? rule.values_array[0]
    end
  end
end
