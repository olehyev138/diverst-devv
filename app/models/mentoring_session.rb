class MentoringSession < BaseClass
  # associations
  belongs_to :creator, class_name: 'User'
  belongs_to :enterprise

  has_many :resources, dependent: :destroy

  has_many :mentoring_session_topics, dependent: :destroy
  has_many :mentoring_interests, through: :mentoring_session_topics
  has_many :mentorship_sessions
  has_many :users, through: :mentorship_sessions
  has_many :mentorship_ratings, dependent: :destroy

  has_many :mentoring_session_comments, dependent: :destroy
  alias_attribute :comments, :mentoring_session_comments

  accepts_nested_attributes_for :mentorship_sessions, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :resources,           reject_if: :all_blank, allow_destroy: true

  # validations
  validates_length_of :notes, maximum: 65535
  validates_length_of :status, maximum: 191
  validates_length_of :video_room_name, maximum: 191
  validates_length_of :access_token, maximum: 65535
  validates_length_of :link, maximum: 191
  validates_length_of :format, maximum: 191
  validates :start,   presence: true
  validates :end,     presence: true
  validates :status,  presence: true
  validates :format,  presence: true

  validates :start,   date: { after: Date.yesterday, message: 'must be today or in the future' }, on: [:create, :update]
  validates :end,     date: { after: :start, message: 'must be after start' }, on: [:create, :update]

  # scopes
  scope :past,            -> { where('end < ?', Time.now.utc) }
  scope :upcoming,        -> { where('end > ?', Time.now.utc) }
  scope :no_ratings,      -> { includes(:mentorship_ratings).where(mentorship_ratings: { id: nil }) }
  scope :with_ratings,    -> { includes(:mentorship_ratings).where.not(mentorship_ratings: { id: nil }) }

  before_create :set_room_name

  after_commit on: [:create] { notify_users_on_create }

  after_update    :notify_users_on_update
  after_destroy   :notify_users_on_destroy

  settings do
    mappings dynamic: false do
      indexes :created_at, type: :date
      indexes :creator do
        indexes :enterprise_id
        indexes :active, type: :boolean
        indexes :first_name, type: :keyword, copy_to: :full_name
        indexes :last_name, type: :keyword, copy_to: :full_name
        indexes :full_name, type: :keyword
      end
    end
  end

  def as_indexed_json(options = {})
    self.as_json(
      options.merge(
        only: [:created_at],
        include: { creator: { only: [:enterprise_id, :active, :first_name, :last_name, :name] } },
      )
    ).merge({ 'created_at' => self.created_at.beginning_of_hour })
  end

  def old_session?
    self.end < Date.today
  end

  def set_room_name
    self.video_room_name = "#{enterprise.name}#{SecureRandom.hex(10)}"
  end

  def can_start(user_id)
    return false if access_token.present?

    mentorship_sessions.where(user_id: user_id, role: 'presenter').count > 0 && Time.now.utc + 5.minutes > start.utc
  end

  def notify_users_on_create
    users.each do |user|
      MentorMailer.session_scheduled(id, user.id).deliver_later
    end
  end

  def notify_users_on_update
    if start_changed? || end_changed?
      users.each do |user|
        MentorMailer.session_updated(user.id, id).deliver_later
      end
    end
  end

  def notify_users_on_destroy
    users.each do |user|
      MentorMailer.session_canceled(start.in_time_zone(user.default_time_zone).strftime('%m/%d/%Y %I:%M %p'), user.id).deliver_later
    end
    mentorship_sessions.destroy_all
  end
end
