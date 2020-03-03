# Custom TextField
#  - value is a string of 'free-form' text written by user
class TextField < Field
  # return list of operator codes for a TextField
  def operators
    [
      Field::OPERATORS[:equals],
      Field::OPERATORS[:is_not],
      Field::OPERATORS[:is_part_of]
    ]
  end

  # -------------------------------------------------------------------------------------------------
  # TODO: Everything below here is most likely deprecated & needs to be removed
  # DEPRECATED
  # -------------------------------------------------------------------------------------------------

  # @deprecated
  def validates_rule_for_user?(rule:, user:)
    case rule.operator
    when SegmentFieldRule.operators[:equals]
      user[rule.field] == rule.values_array[0]
    when SegmentFieldRule.operators[:contains_any_of]
      user[rule.field].include? rule.values_array[0]
    when SegmentFieldRule.operators[:does_not_contain]
      !user[rule.field].include? rule.values_array[0]
    end
  end
end
