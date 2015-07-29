class Enterprise < ActiveRecord::Base
  has_many :admins
  has_many :employees
  has_many :fields

  accepts_nested_attributes_for :fields, reject_if: :all_blank, allow_destroy: true
end
