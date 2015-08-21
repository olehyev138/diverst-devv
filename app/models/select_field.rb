class SelectField < Field
  has_many :options, class_name: "FieldOption", foreign_key: "field_id", dependent: :destroy
  accepts_nested_attributes_for :options, :reject_if => :all_blank, :allow_destroy => true

  def pretty_value(value)
    self.options.find{ |option| option.id == value.to_i }.title
  end

  def match_score_with(other_field)

  end
end
