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
    string_keys_hash = JSON.parse(self.data)
    Hash[string_keys_hash.map{ |k, v| [k.to_i, v] }]
  rescue
    {}
  end

  def info=(new_info)
    self.data = JSON.generate new_info
  end
end
