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
    JSON.parse(self.data)
  rescue
    {}
  end

  def info=(new_info)
    self.data = JSON.generate new_info
    puts "MEOW MEOW MEOW MEOW MEOW MEOW #{self.data}"
  end
end
