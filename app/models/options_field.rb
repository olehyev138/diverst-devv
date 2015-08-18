class OptionsField < Field
  has_many :options, class_name: "FieldOption", dependent: :destroy
  accepts_nested_attributes_for :options, :reject_if => :all_blank, :allow_destroy => true
end
