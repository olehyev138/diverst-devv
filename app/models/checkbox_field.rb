class CheckboxField < OptionsField
  def pretty_value(values)
    return "" if !values
    self.options.select{ |option| values.map(&:to_i).include? option.id }.map{ |option| option.title }.join(', ')
  end
end