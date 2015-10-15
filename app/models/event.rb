class Event < ActiveRecord::Base
  has_and_belongs_to_many :segments
  has_and_belongs_to_many :employees
  belongs_to :group
end
