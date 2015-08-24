class Employee < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :invitable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :enterprise

  before_validation :transfer_info_to_data
  after_initialize :set_info

  attr_accessor :info

  def name
    "#{self.first_name} #{self.last_name}"
  end

  def merge_info(custom_fields)
    self.info = self.info.merge(custom_fields) if custom_fields
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

  protected

  def password_required?
    self.auth_source != "saml"
  end

  def set_info
    self.data = "{}" if self.data.nil?
    json_hash = JSON.parse(self.data)
    self.info = Hash[json_hash.map{|k,v|[ k.to_i, v ]}] # Convert the hash keys to integers since they're strings after JSON parsing
    self.info.extend(FieldData)
  end

  def transfer_info_to_data
    self.data = JSON.generate self.info
  end
end
