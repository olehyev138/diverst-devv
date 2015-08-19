class SelectField < OptionsField
  def pretty_value(value)
    self.options.find{ |option| option.id == value.to_i }.title
  end
end
