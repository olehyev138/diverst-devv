class OptionsField < Field
  has_many :field_options, dependent: :destroy
  accepts_nested_attributes_for :field_options, :reject_if => :all_blank, :allow_destroy => true
end
