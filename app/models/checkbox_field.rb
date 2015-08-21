class CheckboxField < Field
  has_many :options, class_name: "FieldOption", foreign_key: "field_id", dependent: :destroy
  accepts_nested_attributes_for :options, :reject_if => :all_blank, :allow_destroy => true

  def pretty_value(values)
    return "" if !values
    self.options.select{ |option| values.map(&:to_i).include? option.id }.map{ |option| option.title }.join(', ')
  end
end