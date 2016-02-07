class TextField < Field
  def validates_rule_for_user?(rule:, user:)
    case rule.operator
    when SegmentRule.operators[:equals]
      user.info[rule.field] == rule.values_field[0]
    when SegmentRule.operators[:contains]
      user.info[rule.field].contain? rule.values_field[0]
    when SegmentRule.operators[:does_not_contain]
      !user.info[rule.field].contain? rule.values_field[0]
    end
  end
end
