class TextField < Field
  def validates_rule_for_employee?(rule:, employee:)
    case rule.operator
    when GroupRule.operators[:equals]
      employee.info[rule.field] == rule.values_field[0]
    when GroupRule.operators[:contains]
      employee.info[rule.field].contain? rule.values_field[0]
    when GroupRule.operators[:does_not_contain]
      !employee.info[rule.field].contain? rule.values_field[0]
    end
  end
end
