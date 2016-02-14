class PolicyGroup < ActiveRecord::Base
  has_many :users
  belongs_to :enterprise

  accepts_nested_attributes_for :users
end
