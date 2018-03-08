class GroupLeader < ActiveRecord::Base
  belongs_to :group
  belongs_to :user

  validates_presence_of :position_name
  validates_presence_of :group
  validates_presence_of :user
  validates_presence_of :role
  
  scope :visible, ->{ where(visible: true) }
  scope :roles,   ->{ distinct.pluck(:role) }
  
  after_save    :set_user_role
  after_destroy :update_permissions
  
  # want to ensure that the user's role is set accordingly via priority
  # so we retrieve all the group_leader roles, sort by priority and
  # set the role
  
  # user with roles with higher priorty do not have their roles changed
  # ex: user with role priorty of 1 will not have their role changed if
  # the group_leader role priorty is a 2
  
  # note: the lower the number the higher the priority
  
  def set_user_role
    # check if current role is higher priorty
    # if not higher priorty then we retrieve all group_leader roles and set
    # role to the one with highest priority
    
    leader_priority = user.enterprise.user_roles.where(:role_name => role).first.priority
    
    if user.enterprise.user_roles.where(:role_name => user.role).where("priority > ?", leader_priority).count > 0
      # get all the distinct group_leader roles
      group_leader_roles = GroupLeader.joins(:group => :enterprise).where(:groups => {:enterprise_id => group.enterprise.id}, :user_id => user.id).distinct.pluck(:role)
      # set the user role to the role with the highest priority
      user.role = user.enterprise.user_roles.where(:role_name => group_leader_roles).order(:priority).first.role_name
      update_user
    end
  end
  
  # after group leader is removed we want to make sure to set the 
  # user back to default user role in the enterprise but we only do
  # so if the user is no longer a leader of ANY groups and not an admin
  
  def update_permissions
    return if user.admin?
    if !user.erg_leader?
      user.role = user.enterprise.default_user_role
    else
      # get all the distinct group_leader roles
      group_leader_roles = GroupLeader.joins(:group => :enterprise).where(:groups => {:enterprise_id => group.enterprise.id}).where(:user_id => user.id).distinct.pluck(:role)
      # set the user role to the role with the highest priority
      user.role = user.enterprise.user_roles.where(:role_name => group_leader_roles).order(:priority).first.role_name
    end
    update_user
  end
  
  def update_user
    user.save!(validate: false) # bypass validation to allow setting of new user role
    user.set_default_policy_group
  end
  
end
