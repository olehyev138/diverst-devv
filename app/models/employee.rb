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

  before_validation :generate_password_if_saml
  after_create :assign_firebase_token

  scope :for_segments, -> (segments) { joins(:segments).where("segments.id" => segments.map(&:id)) if segments.any? }
  scope :for_groups, -> (groups) { joins(:groups).where("groups.id" => groups.map(&:id)) if groups.any? }
  scope :answered_poll, -> (poll) { joins(:poll_responses).where( poll_responses: { poll_id: poll.id } ) }

  def name
    "#{self.first_name} #{self.last_name}"
  end

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

  def match_score_with(other_employee)
    weight_total = 0
    total_score = 0

    Benchmark.bm do |x|

      x.report do
        employees = self.enterprise.employees.select([:id, :data]).all
        self.enterprise.match_fields.each do |field|
          field_score = field.match_score_between(self, other_employee, employees)

          unless field_score.nil? || field_score.nan?
            weight_total += field.match_weight
            total_score += field.match_weight * field_score
          end
        end
      end

    end

    puts "TOTAL SCORE CALCULATION BENCHERONI"

    puts "TSCORE: #{total_score / weight_total}"
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

  def self.update_match_scores
    self.enterprise.employees.where.not(id: self.id).each do |other_employee|
      CalculateMatchScoreJob.perform_later(self, other_employee, skip_existing: false)
    end
  end

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

  def participation_score
    score = 0

    score += 5 * self.poll_responses.count
    score += 5 * self.answer_upvotes.count
    score += 3 * self.answer_comments.count
    score += 3 * self.enterprise.answer_upvotes.where(answer: self.answers).count
    score += 1 * self.answer_upvotes.count

    score
  end

  # Sends a push notification to all of the user's devices
  def notify(message, data)
    self.devices.each do |device|
      device.notify(message, data)
    end
  end

  def assign_firebase_token
    payload = { uid: self.id.to_s }
    options = { expires: 1.week.from_now }
    self.firebase_token = @@fb_token_generator.create_token(payload, options)
    self.firebase_token_generated_at = Time.zone.now
    self.save
  end

  def as_indexed_json(*)
    self.as_json({
      except: [:data],
      methods: [:combined_info]
    })
  end

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

  def password_required?
    false
  end

  def info_hash
    JSON.parse self.data
  end

  # Returns a hash of all the user's fields combined with all their poll fields
  def combined_info
    polls_hash = self.poll_responses.map(&:info).reduce({}) { |a, b| a.merge(b) }
    self.info_hash.merge(polls_hash) # We use info_hash instead of just info because merge accesses the hash using [], which is overriden in FieldData
  end

  protected

  # Generate a random password if the user is using SAML
  def generate_password_if_saml
    self.password = self.password_confirmation = SecureRandom.urlsafe_base64 if self.auth_source == "saml" && self.new_record?
  end
end
