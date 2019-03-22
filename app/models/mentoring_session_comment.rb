class MentoringSessionComment < BaseClass
  belongs_to :user
  belongs_to :mentoring_session

  validates :user, presence: true
  validates :mentoring_session, presence: true
  validates :content, presence: true
end
