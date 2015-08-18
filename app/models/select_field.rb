class SelectField < OptionsField
  def pretty_value(value)
    self.options.select{ |option| option.id == value.to_i }.first.title
  end
end
