class Group < ActiveRecord::Base
  has_many :user_groups
  has_many :members, through: :user_groups, class_name: 'User', source: :user, after_remove: :update_elasticsearch_member
  belongs_to :enterprise
  has_many :groups_polls
  has_many :polls, through: :groups_polls
  has_many :poll_responses, through: :polls, source: :responses
  has_many :events
  has_many :messages, class_name: 'GroupMessage'
  has_many :news_links
  has_many :invitation_segments_groups
  has_many :invitation_segments, class_name: 'Segment', through: :invitation_segments_groups
  has_many :resources, as: :container
  has_many :campaigns_groups
  has_many :campaigns, through: :campaigns_groups
  has_many :questions, through: :campaigns
  has_many :answers, through: :questions
  has_many :answer_upvotes, through: :answers
  has_many :groups_managers
  has_many :managers, through: :groups_managers, source: :user
  belongs_to :owner, class_name: "User"

  has_attached_file :logo, styles: { medium: '300x300>', thumb: '100x100>' }, default_url: ActionController::Base.helpers.image_path('missing.png')
  validates_attachment_content_type :logo, content_type: %r{\Aimage\/.*\Z}

  before_save :send_invitation_emails, if: :send_invitations?
  before_save :create_yammer_group, if: :should_create_yammer_group?
  before_destroy :handle_deletion
  after_commit :update_all_elasticsearch_members

  scope :top_participants, -> (n) { order(participation_score_7days: :desc).limit(n) }

  def participation_score(from:, to: Time.current)
    score = 0

    score += answers.where('answers.created_at > ?', from).where('answers.created_at < ?', to).count * 5
    score += answer_upvotes.where('answer_upvotes.created_at > ?', from).where('answer_upvotes.created_at < ?', to).count * 1
    score += poll_responses.where('poll_responses.created_at > ?', from).where('poll_responses.created_at < ?', to).count * 5
    score += events.where('created_at > ?', from).where('created_at < ?', to).count * 15
    score += messages.where('created_at > ?', from).where('created_at < ?', to).count * 10
    score += news_links.where('created_at > ?', from).where('created_at < ?', to).count * 10
    score += resources.where('created_at > ?', from).where('created_at < ?', to).count * 10

    score
  end

  def file_safe_name
    name.gsub!(/[^0-9A-Za-z.\-]/, '_')
  end

  def self.create_events
    Group.all.find_each do |group|
      (20 - group.id).times do
        group.events << Event.create(title: 'Test Event', start: 2.days.from_now, end: 2.days.from_now + 2.hours, description: 'This is a placeholder event.')
      end
    end
  end

  def sync_yammer_users
    yammer = YammerClient.new(enterprise.yammer_token)

    # Subscribe users who are part of the ERG in Diverst to the Yammer group
    members.each do |user|
      yammer_user = yammer.user_with_email(user.email)
      next if yammer_user.nil? # Skip user if he/she isn't part of the Yammer network

      # Cache the user's yammer token if it's not
      if user.yammer_token.nil?
        yammer_user_token = yammer.token_for_user(user_id: yammer_user['id'])
        user.update(yammer_token: yammer_user_token['token'])
      end

      # Impersonate the user and subscribe to the group
      user_yammer = YammerClient.new(user.yammer_token)
      user_yammer.subscribe_to_group(yammer_id)
    end
  end

  private

  def create_yammer_group
    # Create the group in Yammer
    yammer = YammerClient.new(enterprise.yammer_token)
    group = yammer.create_group(
      name: name,
      description: description
    )

    unless group['id'].nil?
      update(yammer_group_created: true, yammer_id: group['id'])
      SyncYammerGroupJob.perform_later(self)
    end
  end

  def send_invitation_emails
    GroupMailer.delay.invitation(self, invitation_segments)
    self.send_invitations = false
    invitation_segments.clear
  end

  def should_create_yammer_group?
    yammer_create_group? &&
      !yammer_group_created &&
      !enterprise.yammer_token.nil?
  end

  def update_elasticsearch_member(member)
    member.__elasticsearch__.update_document
  end

  # Update members in elastic_search
  def update_all_elasticsearch_members
    members.each do |member|
      update_elasticsearch_member(member)
    end
  end

  def handle_deletion
    old_members = members.ids

    # Delete member associations
    UserGroup.where(group_id: id).delete_all

    # Update members in elastic_search
    User.where(id: old_members).find_each do |member|
      update_elasticsearch_member(member)
    end
  end
end
