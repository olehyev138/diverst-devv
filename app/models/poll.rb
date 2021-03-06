class Poll < BaseClass
  include PublicActivity::Common

  enum status: [:published, :draft]


  has_many :fields, dependent: :destroy
  has_many :responses, class_name: 'PollResponse', inverse_of: :poll, dependent: :destroy
  has_many :graphs, dependent: :destroy
  has_many :polls_segments, dependent: :destroy
  has_many :segments, inverse_of: :polls, through: :polls_segments
  has_many :groups_polls, dependent: :destroy
  has_many :groups, inverse_of: :polls, through: :groups_polls

  belongs_to :enterprise, inverse_of: :polls, counter_cache: true
  belongs_to :owner, class_name: 'User'
  belongs_to :initiative

  after_commit :create_default_graphs, on: [:create, :update]

  after_commit :schedule_users_notification, on: [:create, :update]

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
    if groups.any?
      target = []
      groups.each do |group|
        target << group.active_members
      end

      target.flatten!
      target_ids = target.map { |u| u.id }

      target = User.where(id: target_ids)
    else
      target = enterprise.users.active
    end

    target = target.for_segments(segments) unless segments.empty?

    target = filter_by_initiative(target) if self.initiative
    target.uniq { |u| u.id }
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
          user_id = response.user_id
          user_email = response.user_email
          user_name = response.user_name
        else
          user_id = ''
          user_email = ''
          user_name = 'Deleted User'
        end
        response_column = [user_id, user_email, user_name]

        fields.each do |field|
          response_column << field.csv_value(response.info[field])
        end

        csv << response_column
      end
    end
  end


  protected

  # Creates one graph per field when the poll is created
  def create_default_graphs
    fields.each do |field|
      field.create_graph(field_id: field.id, poll_id: self.id) if field.graphable? && field.graph.blank?
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
    if (!groups.empty? || !segments.empty?) && !initiative.nil?
      errors.add(:associated_objects, 'invalid configuration of poll')
    end
  end

  def schedule_users_notification
    PollUsersNotifierJob.perform_later(self.id)
  end

  def at_least_one_field
    errors[:base] << 'Survey is invalid without any field' unless fields.any?
  end

  private

  def remove_associated_fields
    fields.delete_all if fields.any?
  end

  def filter_by_initiative(users)
    users.joins(:initiatives).where(initiatives: { id: self.initiative.id })
  end
end
