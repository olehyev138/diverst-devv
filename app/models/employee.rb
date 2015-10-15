class Employee < ActiveRecord::Base
  @@fb_token_generator = Firebase::FirebaseTokenGenerator.new(ENV["FIREBASE_SECRET"])

  # Include default devise modules.
  devise :database_authenticatable, :invitable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :async

  include DeviseTokenAuth::Concerns::User
  include ContainsFields

  belongs_to :enterprise, inverse_of: :employees
  has_many :devices
  has_and_belongs_to_many :segments
  has_and_belongs_to_many :groups
  has_many :topic_feedbacks
  has_many :poll_responses
  has_and_belongs_to_many :events

  before_validation :generate_password_if_saml
  after_create :assign_firebase_token

  def name
    "#{self.first_name} #{self.last_name}"
  end

  def set_info_from_saml(nameid, attrs, enterprise)
    self.email = nameid

    saml_employee_info = {}

    enterprise.fields.each do |field|
      saml_employee_info[field] = attrs[field.saml_attribute] unless field.saml_attribute.blank?
    end

    self.info = self.info.merge(saml_employee_info)

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

  def update_match_scores
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

  # Sends a push notification to all of the user's devices
  def notify(message, data)
    self.devices.each do |device|
      device.notify(message, data)
    end
  end

  def assign_firebase_token
    payload = { uid: self.id.to_s }
    options = { expires: 1.year.from_now }
    self.firebase_token = @@fb_token_generator.create_token(payload)
    self.save
  end

  protected

  # Generate a random password if the user is using SAML
  def generate_password_if_saml
    self.password = self.password_confirmation = SecureRandom.urlsafe_base64 if self.auth_source == "saml" && self.new_record?
  end
end
