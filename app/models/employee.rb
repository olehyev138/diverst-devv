class Employee < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :invitable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :enterprise

  def name
    "#{self.first_name} #{self.last_name}"
  end

  def info
    string_keys_info = JSON.parse(self.data)
    data_hash = Hash[string_keys_info.map{ |k, v| [k.to_i, v] }]
  rescue
    {}
  end

  def info=(new_info)
    self.data = JSON.generate new_info
  end

  def info_for_field(field)
    return "-" if !self.info[field.id]
    field.pretty_value self.info[field.id]
  end

  def merge_info(custom_fields)
    self.info = self.info.merge(custom_fields) if custom_fields
  end

  def set_info_from_saml(nameid, attrs, enterprise)
    self.email = nameid

    saml_employee_info = {}

    enterprise.fields.each do |field|
      saml_employee_info[field.id] = attrs[field.saml_attribute] unless field.saml_attribute.blank?
    end

    pp(saml_employee_info)
    pp(self.info)

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
end
