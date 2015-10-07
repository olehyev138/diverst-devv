class Group < ActiveRecord::Base
  has_and_belongs_to_many :members, class_name: "Employee"
  belongs_to :enterprise
  has_and_belongs_to_many :polls
end
