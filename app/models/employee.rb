class Employee < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :saml_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :enterprise

  def name
    "#{self.first_name} #{self.last_name}"
  end

  protected

  def password_required?
    false
  end
end
