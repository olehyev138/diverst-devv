class TextField < Field
  def validates_rule_for_employee?(rule:, employee:)
    case rule.operator
    when SegmentRule.operators[:equals]
      employee.info[rule.field] == rule.values_field[0]
    when SegmentRule.operators[:contains]
      employee.info[rule.field].contain? rule.values_field[0]
    when SegmentRule.operators[:does_not_contain]
      !employee.info[rule.field].contain? rule.values_field[0]
    end
  end
end
