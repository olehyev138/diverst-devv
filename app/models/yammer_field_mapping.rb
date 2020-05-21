class YammerFieldMapping < BaseClass
  belongs_to :enterprise
  belongs_to :diverst_field, class_name: 'Field'
  validates_length_of :yammer_field_name, maximum: 191
end
