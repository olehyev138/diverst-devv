class GroupLeader < ActiveRecord::Base
  belongs_to :group
  belongs_to :user

  validates_presence_of :position_name
  validates_presence_of :group
  validates_presence_of :user
  validates_presence_of :role
  
  scope :visible, ->{ where(visible: true) }
  
  after_save    :set_user_role
  after_destroy :update_permissions
  
  def set_user_role
    user.role = role
    user.save!
    user.set_default_policy_group
  end
  
  # after group leader is removed we want to make sure to set the 
  # user back to default user role in the enterprise but we only do
  # so if the user is no longer a leader of ANY groups and not an admin
  
  def update_permissions
    if !user.erg_leader? and !user.admin?
      user.role = user.enterprise.default_user_role
      user.set_default_policy_group
    end
  end
  
end
