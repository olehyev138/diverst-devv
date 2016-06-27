class Department < ActiveRecord::Base
  belongs_to :enterprise
  validates_presence_of :enterprise

  validates :name, presence: true
end
