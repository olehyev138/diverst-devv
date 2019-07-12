class Device < ApplicationRecord
  # associations
  belongs_to :user

  # validations
  validates   :user,    presence: true
  validates   :token,   presence: true

  # only allow one unique token per user
  validates_uniqueness_of :token
end
