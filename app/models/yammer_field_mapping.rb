class YammerFieldMapping < ApplicationRecord
  belongs_to :enterprise
  belongs_to :diverst_field, class_name: 'Field'
end
