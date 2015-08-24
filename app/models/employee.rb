class Employee < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :invitable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :enterprise

  before_validation :transfer_info_to_data
  before_validation :generate_password_if_saml
  after_initialize :set_info

  attr_accessor :info

  def name
    "#{self.first_name} #{self.last_name}"
  end

  def merge_info(custom_fields)
    return if !custom_fields

    self.enterprise.fields.each do |field|
      self.info[field] = custom_fields[field.id.to_s]
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

  protected

  def set_info
    self.data = "{}" if self.data.nil?
    json_hash = JSON.parse(self.data)
    self.info = Hash[json_hash.map{|k,v|[ k.to_i, v ]}] # Convert the hash keys to integers since they're strings after JSON parsing
    self.info.extend(FieldData)
  end

  # Generate a random password if the user is using SAML
  def generate_password_if_saml
    self.password = self.password_confirmation = SecureRandom.urlsafe_base64 if self.auth_source == "saml" && self.new_record?
  end

  def transfer_info_to_data
    self.data = JSON.generate self.info
  end
end
