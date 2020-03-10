class InitiativeUser < ApplicationRecord
  belongs_to :initiative
  belongs_to :user

  validates_presence_of :initiative
  validates_presence_of :user
  validates_uniqueness_of :user, scope: [:initiative], message: 'has already joined this event'
end
