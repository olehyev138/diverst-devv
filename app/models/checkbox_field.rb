class CheckboxField < Field
  include Optionnable

  def serialize_value(value)
    Array(value)
  end

  def string_value(value)
    return "-" if !value
    value.join(', ')
  end

  def match_score_between(e1, e2)
    puts "MEOW"
    pp e1.info[self]
    0.5
  end
end