class GroupLeader < ActiveRecord::Base
  belongs_to :group
  belongs_to :user

  validates_presence_of :position_name
  validates_presence_of :group
  validates_presence_of :user
  validates_presence_of :role
  
  scope :visible, ->{ where(visible: true) }
  
  after_save :set_user_role
  
  def set_user_role
    user.role = role
    user.set_default_policy_group
  end
  
end
