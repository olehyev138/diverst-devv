class Admin < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable, :async

  include DeviseInvitable::Inviter

  belongs_to :enterprise, inverse_of: :admins
  has_many :topics, inverse_of: :admin
end
