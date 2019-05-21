class MentoringSessionTopic < BaseClass
  # associations
  belongs_to  :mentoring_session
  belongs_to  :mentoring_interest

  # validations
  validates :mentoring_session,  presence: true
  validates :mentoring_interest, presence: true
end
