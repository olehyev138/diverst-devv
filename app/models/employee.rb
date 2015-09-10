class Employee < ActiveRecord::Base
  @@fb_token_generator = Firebase::FirebaseTokenGenerator.new(ENV["FIREBASE_SECRET"])

  # Include default devise modules.
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable

  include DeviseTokenAuth::Concerns::User

  belongs_to :enterprise, inverse_of: :employees
  has_many :devices
  has_and_belongs_to_many :groups

  before_validation :transfer_info_to_data
  before_validation :generate_password_if_saml
  after_initialize :set_info
  after_create :assign_firebase_token

  attr_accessor :info

  def name
    "#{self.first_name} #{self.last_name}"
  end

  def merge_info(custom_fields)
    return if !custom_fields

    self.enterprise.fields.each do |field|
      new_value = custom_fields[field.id.to_s]

      if new_value.nil?
        self.info[field] = nil
      else
        self.info[field] = custom_fields[field.id.to_s]
      end
    end
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
    Match.active_for(self)
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

  def is_part_of_group?(group)
    part_of_group = true

    group.rules.each do |rule|
      unless rule.followed_by?(self)
        part_of_group = false
        break;
      end
    end

    part_of_group
  end

  protected

  def set_info
    self.data = "{}" if self.data.nil?
    json_hash = JSON.parse(self.data)
    self.info = Hash[json_hash.map{|k,v|[ k.to_i, v ]}] # Convert the hash keys to integers since they're strings after JSON parsing
    self.info.extend(FieldData)
  end

  def assign_firebase_token
    payload = { uid: self.id.to_s }
    options = { expires: 1.year.from_now }
    self.firebase_token = @@fb_token_generator.create_token(payload)
    self.save
  end

  # Generate a random password if the user is using SAML
  def generate_password_if_saml
    self.password = self.password_confirmation = SecureRandom.urlsafe_base64 if self.auth_source == "saml" && self.new_record?
  end

  def transfer_info_to_data
    self.data = JSON.generate self.info
  end
end
