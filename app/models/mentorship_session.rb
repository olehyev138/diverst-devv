class MentorshipSession < BaseClass
  # associations
  belongs_to :user
  belongs_to :mentoring_session

  # validations
  validates_length_of :status, maximum: 191
  validates_length_of :role, maximum: 191
  validates :user,                presence: true
  validates :role,                presence: true
  validates :mentoring_session,   presence: true, on: :update

  validates_uniqueness_of :user_id, scope: [:mentoring_session_id]

  def creator?
    self.mentoring_session.creator_id == self.user_id
  end

  # Status getters and setters

  def pending
    self.status = 'pending'
  end

  def accept
    self.status = 'accepted'
  end

  def decline
    self.status = 'declined'
  end

  def pending?
    self.status == 'pending'
  end

  def accepted?
    self.status == 'accepted'
  end

  def declined?
    self.status == 'declined'
  end
end
