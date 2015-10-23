class MobileField < ActiveRecord::Base
  belongs_to :field
  belongs_to :enterprise
end
