class Employee < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
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
    field.pretty_value self.info[field.id]
  end

  def merge_info(custom_fields)
    self.info = self.info.merge(custom_fields) if custom_fields
  end
end
