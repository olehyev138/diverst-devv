class YammerFieldMapping < ActiveRecord::Base
  belongs_to :enterprise
  belongs_to :diverst_field, class_name: 'Field'
end
