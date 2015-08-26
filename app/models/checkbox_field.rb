class CheckboxField < Field
  has_many :options, class_name: "FieldOption", foreign_key: "field_id", dependent: :destroy
  accepts_nested_attributes_for :options, :reject_if => :all_blank, :allow_destroy => true

  def serialize_value(value)
    Array(value)
  end

  def string_value(value)
    return "-" if !value
    self.options.select{ |option| value.map(&:to_i).include? option.id }.map{ |option| option.title }.join(', ')
  end
end