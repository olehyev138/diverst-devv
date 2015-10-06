class Poll < ActiveRecord::Base
  has_many :fields
  has_many :segments
  has_many :groups
end
