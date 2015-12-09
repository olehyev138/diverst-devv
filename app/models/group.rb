class Group < ActiveRecord::Base
  has_many :employee_groups, dependent: :destroy
  has_many :members, through: :employee_groups, class_name: "Employee", source: :employee
  belongs_to :enterprise
  has_and_belongs_to_many :polls
  has_many :poll_responses, through: :polls, source: :responses
  has_many :events
  has_many :messages, class_name: "GroupMessage"
  has_many :news_links
  has_and_belongs_to_many :invitation_segments, class_name: "Segment", join_table: "invitation_segments_groups"
  has_many :resources, as: :container
  has_and_belongs_to_many :campaigns
  has_many :questions, through: :campaigns
  has_many :answers, through: :questions
  has_many :answer_upvotes, through: :answers

  has_attached_file :logo, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: ActionController::Base.helpers.image_path("missing.png")
  validates_attachment_content_type :logo, content_type: /\Aimage\/.*\Z/

  before_save :send_invitation_emails, if: :send_invitations?

  scope :top_participants, -> (n) { order(participation_score_7days: :desc).limit(n) }

  def participation_score(from:, to: Time.now)
    score = 0

    score += answers.where("answers.created_at > ?", from).where("answers.created_at < ?", to).count * 5
    score += answer_upvotes.where("answer_upvotes.created_at > ?", from).where("answer_upvotes.created_at < ?", to).count * 1
    score += poll_responses.where("poll_responses.created_at > ?", from).where("poll_responses.created_at < ?", to).count * 5
    score += events.where("created_at > ?", from).where("created_at < ?", to).count * 15
    score += messages.where("created_at > ?", from).where("created_at < ?", to).count * 10
    score += news_links.where("created_at > ?", from).where("created_at < ?", to).count * 10
    score += resources.where("created_at > ?", from).where("created_at < ?", to).count * 10

    score
  end

  protected

  def send_invitation_emails
    GroupMailer.delay.invitation(self, self.invitation_segments)
    self.send_invitations = false
    self.invitation_segments.clear
  end
end
