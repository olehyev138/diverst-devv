class Poll < ActiveRecord::Base
  enum status: [:published, :draft]

  has_many :fields, as: :container
  has_many :responses, class_name: 'PollResponse', inverse_of: :poll
  has_many :graphs, as: :collection
  has_many :polls_segments
  has_many :segments, inverse_of: :polls, through: :polls_segments
  has_many :groups_polls
  has_many :groups, inverse_of: :polls, through: :groups_polls
  belongs_to :enterprise, inverse_of: :polls
  belongs_to :owner, class_name: "User"

  after_create :send_invitation_emails
  after_create :create_default_graphs

  accepts_nested_attributes_for :fields, reject_if: :all_blank, allow_destroy: true

  validates :status, presence: true

  # Returns the list of users who have answered the poll
  def graphs_population
    User.answered_poll(self)
  end

  # Returns the list of users who meet the participation criteria for the poll
  def targeted_users
    target = User.all

    target = target.for_segments(segments) unless segments.empty?

    target = target.for_groups(groups) unless groups.empty?

    target
  end

  # Defines which fields will be usable when creating graphs
  def graphable_fields(admin)
    admin.enterprise.fields + fields
  end

  def responses_csv
    CSV.generate do |csv|
      csv << ['id'].concat(fields.map(&:title))

      responses.order(created_at: :desc).each do |response|
        response_column = [response.id]

        fields.each do |field|
          response_column << field.csv_value(response.info[field])
        end

        csv << response_column
      end
    end
  end

  protected

  def send_invitation_emails
    targeted_users.each do |user|
      PollMailer.delay.invitation(self, user)
    end
  end

  # Creates one graph per field when the poll is created
  def create_default_graphs
    fields.each do |field|
      graphs.create(field: field) if field.graphable?
    end
  end
end
