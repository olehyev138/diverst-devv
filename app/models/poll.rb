class Poll < ApplicationRecord
  include PublicActivity::Common
  include Poll::Actions
  include DefinesFields

  @@field_users = [:responses]
  mattr_reader :field_users

  enum status: [:published, :draft]

  has_many :fields,
           as: :field_definer,
           dependent: :destroy,
           after_add: :add_missing_field_background_job
  has_many :responses,
           class_name: 'PollResponse',
           inverse_of: :poll,
           dependent: :destroy
  has_many :graphs, dependent: :destroy
  has_many :polls_segments, dependent: :destroy
  has_many :segments, inverse_of: :polls, through: :polls_segments
  has_many :groups_polls, dependent: :destroy
  has_many :groups, inverse_of: :polls, through: :groups_polls
  has_many :user_poll_tokens, -> { where cancelled: false }, inverse_of: :poll, dependent: :destroy
  has_many :cancelled_user_poll_tokens, -> { where cancelled: true }, class_name: 'UserPollToken', inverse_of: :poll, dependent: :destroy
  has_many :token_users, class_name: 'User', through: :user_poll_tokens, source: :user

  belongs_to :enterprise, inverse_of: :polls, counter_cache: true
  belongs_to :owner, class_name: 'User'
  belongs_to :initiative

  after_create :create_default_graphs
  after_commit :schedule_users_notification, on: [:create, :update], unless: :draft?

  before_destroy :remove_associated_fields, prepend: true

  accepts_nested_attributes_for :fields, reject_if: :all_blank, allow_destroy: true

  validates_length_of :description, maximum: 65535
  validates_length_of :title, maximum: 191
  validates :title,       presence: true
  validates :description, presence: true
  validates :status,      presence: true
  validates :enterprise,  presence: true
  validates :owner,       presence: true
  # validates :groups,      presence: {:message => "Please choose at least 1 group"}

  validate :validate_groups_enterprise
  validate :validate_initiative_enterprise
  validate :validate_segments_enterprise
  validate :validate_associated_objects
  validate :at_least_one_field

  def can_be_saved_as_draft?
    self.new_record? || self.draft?
  end

  # Returns the list of users who have answered the poll
  def graphs_population
    User.answered_poll(self)
  end

  # Returns the list of users who meet the participation criteria for the poll
  def targeted_users
    @targeted_users ||= targeted_users_load
  end

  def targeted_users_count
    targeted_users.size
  end

  def update_tokens
    to_create, to_cancel, to_uncancel = user_diff

    user_poll_tokens.create(to_create.map { |create_user_id| { user_id: create_user_id } })
    user_poll_tokens.where(user_id: to_cancel).update_all(cancelled: true)
    cancelled_user_poll_tokens.where(user_id: to_uncancel).update_all(cancelled: false)
    reload
  end

  # Defines which fields will be usable when creating graphs
  def graphable_fields(admin)
    admin.enterprise.fields + fields
  end

  def responses_csv
    CSV.generate do |csv|
      csv << ['user_id', 'user_email', 'user_name'].concat(fields.map(&:title))

      responses.order(created_at: :desc).each do |response|
        if response.user.present?
          user_id = response.user.id
          user_email = response.user.email
          user_name = response.user.name
        else
          user_id = ''
          user_email = ''
          user_name = 'Deleted User'
        end
        response_column = [user_id, user_email, user_name]

        response.field_data.load
        fields.each do |field|
          response_column << field.csv_value(response[field])
        end

        csv << response_column
      end
    end
  end

  def fields_count
    fields.size
  end

  protected

  # Creates one graph per field when the poll is created
  def create_default_graphs
    fields.each do |field|
      graphs.create(field: field) if field.graphable?
    end
  end

  def validate_groups_enterprise
    if !groups.empty? && groups.map(&:enterprise_id).uniq != [enterprise_id]
      errors.add(:groups, 'is invalid')
    end
  end

  def validate_segments_enterprise
    if !segments.empty? && segments.map(&:enterprise_id).uniq != [enterprise_id]
      errors.add(:segments, 'is invalid')
    end
  end

  def validate_initiative_enterprise
    if !initiative.nil? && !enterprise.initiatives.where(id: initiative_id).exists?
      errors.add(:initiative, 'is invalid')
    end
  end

  def validate_associated_objects
    if (!groups.empty?) && !initiative.nil?
      errors.add(:associated_objects, 'invalid configuration of poll')
    end
  end

  def schedule_users_notification
    PollUsersNotifierJob.perform_later(self.id)
  end

  def at_least_one_field
    errors[:base] << 'Survey is invalid without any field' unless fields.any? rescue nil
  end

  private

  def remove_associated_fields
    fields.delete_all if fields.any?
  end

  # Use to get the following list
  # - The list of users who are allowed to take the survey, but do not have a token
  # - A list of users who are NOT allowed to take the survey, but have a valid token
  # - A list of users who are allowed to take the survey, but have an invalidated token
  def user_diff
    targets = targeted_users_load.pluck(:id)
    old_valid_targets = user_poll_tokens.pluck(:user_id)
    old_cancelled_targets = cancelled_user_poll_tokens.pluck(:user_id)

    to_cancel = old_valid_targets - targets
    to_uncancel = targets & old_cancelled_targets
    to_create = targets - old_valid_targets - old_cancelled_targets

    [to_create, to_cancel, to_uncancel]
  end

  # Forcefully loads the list of users who are allowed to take the survey
  # If groups are defined, take the accepted members of the groups
  # If an event is defined, take the attendees of that event
  # Otherwise take all the users of an enterprise
  #
  # Then Filter the user on segments (no defined segments mean every user)
  def targeted_users_load
    if groups.any?
      target = User.joins(:groups).where(groups: { id: groups.ids }, user_groups: { accepted_member: true }).active
    elsif initiative_id.present?
      target = initiative.attendees.active
    else
      target = enterprise.users.active
    end
    target = target.for_segments(segments)
    target.distinct
  end
end
