class MentoringSessionRequest < ActiveRecord::Base
  belongs_to :mentoring_session
  belongs_to :user

  validates :user_id, uniqueness: { scope: :mentoring_session }

  scope :user_requests, -> (user_id) { where(user_id: user_id) }

  def self.user_request(user_id)
    user_requests(user_id).first
  end

  def pending
    self.status = "pending"
  end

  def accept
    self.status = "accepted"
  end

  def decline
    self.status = "declined"
  end

  def pending?
    self.status == "pending"
  end

  def accepted?
    self.status == "accepted"
  end

  def declined?
    self.status == "declined"
  end
end
