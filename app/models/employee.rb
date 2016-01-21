class Employee < ActiveRecord::Base
  @@fb_token_generator = Firebase::FirebaseTokenGenerator.new(ENV["FIREBASE_SECRET"])

  # Include default devise modules.
  devise :database_authenticatable, :invitable,
         :recoverable, :rememberable, :trackable, :validatable, :async

  include DeviseTokenAuth::Concerns::User
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  include ContainsFields
  include IsUser

  has_many :devices
  has_and_belongs_to_many :segments
  has_many :employee_groups
  has_many :groups, through: :employee_groups
  has_many :topic_feedbacks
  has_many :poll_responses
  has_many :answers, inverse_of: :author, foreign_key: :author_id
  has_many :answer_upvotes, foreign_key: :author_id
  has_many :answer_comments, foreign_key: :author_id
  has_many :invitations, class_name: "CampaignInvitation"
  has_many :campaigns, through: :invitations
  has_many :news_links, through: :groups
  has_many :messages, through: :groups
  has_many :events, through: :groups
  has_many :managed_groups, foreign_key: :manager_id, class_name: "Group"

  before_validation :generate_password_if_saml
  after_create :assign_firebase_token

  scope :for_segments, -> (segments) { joins(:segments).where("segments.id" => segments.map(&:id)).distinct if segments.any? }
  scope :for_groups, -> (groups) { joins(:groups).where("groups.id" => groups.map(&:id)).distinct if groups.any? }
  scope :answered_poll, -> (poll) { joins(:poll_responses).where( poll_responses: { poll_id: poll.id } ) }
  scope :top_participants, -> (n) { order(participation_score_7days: :desc).limit(n) }

  def name
    "#{self.first_name} #{self.last_name}"
  end

  # Update the user with info from the SAML auth response
  def set_info_from_saml(nameid, _attrs, enterprise)
    self.email = nameid

    saml_employee_info = {}

    self.info = self.info.merge(fields: self.enterprise.fields, form_data: saml_employee_info)

    self.save!
    enterprise.employees << self
    enterprise.save!

    self
  end

  def string_for_field(field)
    field.string_value self.info[field]
  end

  # Get the match score between the employee and `other_employee`
  def match_score_with(other_employee)
    weight_total = 0
    total_score = 0

    employees = self.enterprise.employees.select([:id, :data]).all
    self.enterprise.match_fields.each do |field|
      field_score = field.match_score_between(self, other_employee, employees)

      unless field_score.nil? || field_score.nan?
        weight_total += field.match_weight
        total_score += field.match_weight * field_score
      end
    end

    total_score / weight_total
  end

  def matches
    Match.has_employee(self)
  end

  def active_matches
    Match.active_for(self).not_archived
  end

  # Get the n top unswiped matches for the user
  def top_matches(n = 10)
    self.active_matches.order(score: :desc).limit(n)
  end

  # Checks if the user is part of the specified segment
  def is_part_of_segment?(segment)
    part_of_segment = true

    segment.rules.each do |rule|
      unless rule.followed_by?(self)
        part_of_segment = false
        break
      end
    end

    part_of_segment
  end

  # Get a score indicating the user's participation in the platform
  def participation_score(from:, to: Time.now)
    score = 0

    score += 5 * self.poll_responses.where("created_at > ?", from).where("created_at <= ?", to).count
    score += 5 * self.answers.where("created_at > ?", from).where("created_at <= ?", to).count
    score += 3 * self.enterprise.answer_upvotes.where(answer: self.answers).where("answers.created_at > ?", from).where("answers.created_at <= ?", to).count
    score += 3 * self.answer_comments.where("created_at > ?", from).where("created_at <= ?", to).count
    score += 1 * self.answer_upvotes.where("created_at > ?", from).where("created_at <= ?", to).count # 1 point per upvote given

    score
  end

  # Sends a push notification to all of the user's devices
  def notify(message, data)
    self.devices.each do |device|
      device.notify(message, data)
    end
  end

  # Generate a Firebase token for the user and update the user with it
  def assign_firebase_token
    payload = { uid: self.id.to_s }
    options = { expires: 1.week.from_now }
    self.firebase_token = @@fb_token_generator.create_token(payload, options)
    self.firebase_token_generated_at = Time.now
    self.save
  end

  # Add the combined info from both the employee's fields and his/her poll answers to ES
  def as_indexed_json(*)
    self.as_json({
      except: [:data],
      methods: [:combined_info]
    })
  end

  # Custom ES mapping that creates an unanalyzed version of all string fields for exact-match term queries
  def self.mappingue
    {
      employee: {
        dynamic_templates: [{
          string_template: {
            type: "string",
            mapping: {
              fields: {
                raw: {
                  type: "string",
                  index: "not_analyzed"
                }
              }
            },
            match_mapping_type: "string",
            match: "*"
          }
        }],
        properties: {}
      }
    }
  end

  # Deletes the ES index, creates a new one and imports all employees in it
  def self.reset_elasticsearch(enterprise:)
    index = enterprise.es_employees_index_name

    Employee.__elasticsearch__.client.indices.delete index: index rescue nil

    Employee.__elasticsearch__.client.indices.create(
      index: index,
      body: {
        settings: Employee.settings.to_hash,
        mappings: Employee.mappingue.to_hash
      }
    )

    Employee.import index: index
  end

  # Updates this employee's match scores with all other enterprise employees
  def update_match_scores
    self.enterprise.employees.where.not(id: self.id).each do |other_employee|
      CalculateMatchScoreJob.perform_later(self, other_employee, skip_existing: false)
    end
  end

  # Initializes an employee from a yammer user
  def self.from_yammer(yammer_user, enterprise:)
    employee = Employee.new(
      first_name: yammer_user["first_name"],
      last_name: yammer_user["last_name"],
      email: yammer_user["contact"]["email_addresses"][0]["address"],
      auth_source: "yammer",
      enterprise: enterprise
    )

    # Map Yammer fields with Diverst fields as per the mappings defined in the integration configuration
    enterprise.yammer_field_mappings.each do |mapping|
      employee.info[mapping.diverst_field] = yammer_user[mapping.yammer_field_name]
    end

    employee
  end

  # Initializes an employee from a CSV row
  def self.from_csv_row(row, enterprise:)
    return nil if row[0].nil? || row[1].nil? || row[2].nil? # Require first_name, last_name and email

    employee = Employee.new(
      first_name: row[0],
      last_name: row[1],
      email: row[2],
      enterprise: enterprise
    )

    enterprise.fields.each_with_index do |field, i|
      employee.info[field] = field.process_field_value row[3+i]
    end

    employee
  end

  # Is set to false to allow users to login via SAML without a password
  def password_required?
    false
  end

  # Raw hash of employee info needed when the FieldData Hash[] overrides are an annoyance
  def info_hash
    return {} if self.data.nil?
    JSON.parse self.data
  end

  # Returns a hash of all the user's fields combined with all their poll fields
  def combined_info
    combined_hash = {}

    polls_hash = self.poll_responses.map(&:info).reduce({}) { |a, b| a.merge(b) } # Get a hash of all the combined poll response answers for this employee
    groups_hash = { groups: self.groups.ids }
    segments_hash = { segments: self.segments.ids }

    # Merge all the hashes to the main info hash
    # We use info_hash instead of just info because Hash#merge accesses uses [], which is overriden in FieldData
    self.info_hash
      .merge(polls_hash)
      .merge(groups_hash)
      .merge(segments_hash)
  end

  # Export a CSV with the specified employees
  def self.to_csv(employees:, fields:, nb_rows: nil)
    CSV.generate do |csv|
      csv << ["id", "First name", "Last name", "Email"].concat(fields.map(&:title))

      employees.order(created_at: :desc).limit(nb_rows).each do |employee|
        employee_columns = [employee.id, employee.first_name, employee.last_name, employee.email]

        fields.each do |field|
          employee_columns << field.csv_value(employee.info[field])
        end

        csv << employee_columns
      end
    end
  end

  private

  # Generate a random password if the user is using SAML
  def generate_password_if_saml
    self.password = self.password_confirmation = SecureRandom.urlsafe_base64 if self.auth_source == "saml" && self.new_record?
  end
end
