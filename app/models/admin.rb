class Admin < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
    :recoverable, :rememberable, :trackable, :validatable, :async

  include DeviseInvitable::Inviter
  include IsUser

  has_many :topics, inverse_of: :admin

  scope :not_owners, -> { where(owner: false) }
end
