class GroupLeader < ActiveRecord::Base
  belongs_to :group
  belongs_to :user
  belongs_to :user_role
  
  validates_presence_of :position_name
  validates_presence_of :group
  validates_presence_of :user
  validates_presence_of :user_role
  
  scope :visible,   ->{ where(visible: true) }
  scope :role_ids,  ->{ distinct.pluck(:user_role_id) }
  
  after_validation  :set_admin_permissions
  after_save        :set_user_role
  after_destroy     :update_permissions
  
  # we want to make sure the group_leader can access certain
  # resources in the admin view
  
  def set_admin_permissions
    # get the template that corresponds to the group_leader role
    template = PolicyGroupTemplate.joins(:user_role).where(:user_roles => {:id => user_role_id}).first
    
    # update the permissions for this group_leader
    self.groups_budgets_index = template.groups_budgets_index
    self.initiatives_manage = template.initiatives_manage
    self.groups_manage = template.groups_manage
  end
  
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
    
    leader_priority = user.enterprise.user_roles.where(:id => user_role_id).first.priority
    
    if user.enterprise.user_roles.where(:id => user.user_role_id).where("priority > ?", leader_priority).count > 0
      # get all the distinct group_leader roles
      group_leader_role_ids = GroupLeader.joins(:group => :enterprise).where(:groups => {:enterprise_id => group.enterprise.id}, :user_id => user.id).distinct.pluck(:user_role_id)
      # set the user role to the role with the highest priority
      user.user_role_id = user.enterprise.user_roles.where(:id => group_leader_role_ids).order(:priority).first.id
      update_user
    end
  end
  
  # after group leader is removed we want to make sure to set the 
  # user back to default user role in the enterprise but we only do
  # so if the user is no longer a leader of ANY groups and not an admin
  
  def update_permissions
    return if user.admin?
    if !user.erg_leader?
      user.user_role_id = user.enterprise.default_user_role
    else
      # get all the distinct group_leader roles
      group_leader_role_ids = GroupLeader.joins(:group => :enterprise).where(:groups => {:enterprise_id => group.enterprise.id}).where(:user_id => user.id).distinct.pluck(:user_role_id)
      
      # set the user role to the role with the highest priority
      user.user_role_id = user.enterprise.user_roles.where(:id => group_leader_role_ids).order(:priority).first.id
    end
    update_user
  end
  
  def update_user
    user.save!(validate: false) # bypass validation to allow setting of new user role
    user.set_default_policy_group
  end
  
end
