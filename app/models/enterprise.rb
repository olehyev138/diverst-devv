class Enterprise < ActiveRecord::Base
  has_many :admins
  has_many :employees
end
