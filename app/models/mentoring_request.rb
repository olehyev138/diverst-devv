class MentoringRequest < ApplicationRecord
  include PublicActivity::Common
  include MentoringRequest::Actions

  # associations
  has_many :mentoring_request_interests
  has_many :mentoring_interests, through: :mentoring_request_interests

  belongs_to :enterprise
  belongs_to :sender,     class_name: 'User'
  belongs_to :receiver,   class_name: 'User'

  # validations
  validates_length_of :mentoring_type, maximum: 191
  validates_length_of :notes, maximum: 65535
  validates_length_of :status, maximum: 191
  validates :status,      presence: true
  validates :sender,      presence: true
  validates :receiver,    presence: true

  # only allow one unique request per sender
  validates_uniqueness_of :sender_id, scope: [:receiver_id], message: "There's already a pending request"

  validate :receiver_has_requests_enabled, on: :create

  after_create :notify_receiver

  scope :mentor_requests, -> { where(mentoring_type: 'mentor') }
  scope :mentee_requests, -> { where(mentoring_type: 'mentee') }

  scope :pending, -> { where(status: 'pending') }
  scope :accepted, -> { where(status: 'accepted') }
  scope :denied, -> { where(status: 'denied') }

  def notify_receiver
    MentorMailer.new_mentoring_request(id).deliver_later
  end

  def notify_declined_request
    MentorMailer.notify_declined_request(receiver_id, sender_id).deliver_later
  end

  def notify_accepted_request
    MentorMailer.notify_accepted_request(receiver_id, sender_id).deliver_later
  end

  protected

  def receiver_has_requests_enabled
    if self.mentoring_type == 'mentor' && !self.receiver.accepting_mentor_requests
      errors.add(:receiver, 'is not currently accepting mentor requests')
    elsif self.mentoring_type == 'mentee' && !self.receiver.accepting_mentee_requests
      errors.add(:receiver, 'is not currently accepting mentee requests')
    end
  end
end
