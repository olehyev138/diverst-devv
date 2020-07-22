class UserPollToken < ApplicationRecord
  belongs_to :user
  belongs_to :poll

  has_secure_token :token

  after_create :regenerate_token
  validates_uniqueness_of :user_id, scope: :poll_id
end
