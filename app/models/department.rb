class Department < ActiveRecord::Base
  belongs_to :enterprise

  validates :name, presence: true
end
