class MentorshipRating < BaseClass
  # associations
  belongs_to :user
  belongs_to :mentoring_session

  # validations
  validates_length_of :comments, maximum: 65535
  validates :user,                presence: true
  validates :mentoring_session,   presence: true
  validates :rating,              presence: true
end
