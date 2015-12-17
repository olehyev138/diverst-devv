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
  before_save :create_yammer_group, if: :should_create_yammer_group?

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

  def file_safe_name
    self.name.gsub!(/[^0-9A-Za-z.\-]/, '_')
  end

  def self.create_events
    Group.all.each do |group|
      (20 - group.id).times do
        group.events << Event.create(title: "Test Event", start: 2.days.from_now, end: 2.days.from_now + 2.hours, description: "This is a placeholder event.")
      end
    end
  end

  def sync_yammer_employees
    yammer = YammerClient.new(self.enterprise.yammer_token)

    # Subscribe employees who are part of the ERG in Diverst to the Yammer group
    self.members.each do |employee|
      yammer_user = yammer.user_with_email(employee.email)
      next if yammer_user.nil? # Skip employee if he/she isn't part of the Yammer network

      # Cache the employee's yammer token if it's not
      if employee.yammer_token.nil?
        yammer_user_token = yammer.token_for_user(user_id: yammer_user["id"])
        employee.update(yammer_token: yammer_user_token["token"])
      end

      # Impersonate the employee and subscribe to the group
      employee_yammer = YammerClient.new(employee.yammer_token)
      employee_yammer.subscribe_to_group(self.yammer_id)
    end
  end

  private

  def create_yammer_group
    # Create the group in Yammer
    yammer = YammerClient.new(self.enterprise.yammer_token)
    group = yammer.create_group(
      name: self.name,
      description: self.description
    )

    if !group["id"].nil?
      self.update(yammer_group_created: true, yammer_id: group["id"])
      SyncYammerGroupJob.perform_later(self)
    end
  end

  def send_invitation_emails
    GroupMailer.delay.invitation(self, self.invitation_segments)
    self.send_invitations = false
    self.invitation_segments.clear
  end

  def should_create_yammer_group?
    yammer_create_group? &&
    !yammer_group_created &&
    !self.enterprise.yammer_token.nil?
  end
end
