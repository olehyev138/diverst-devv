class BusinessImpact < ActiveRecord::Base
  belongs_to :enterprise

  validates :name, presence: true
end
