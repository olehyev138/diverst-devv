class AddUserRoleIdToAssociations < ActiveRecord::Migration
  def up
    # add user_role id to users and group leaders so we can maintain the same name
    # and track the user role by ID
    add_reference :users,         :user_role
    add_reference :group_leaders, :user_role
    
    # update the role id on users and group leaders
    Enterprise.find_each do |enterprise|
       enterprise.user_roles.find_each do |user_role|
         enterprise.users.where(:role => user_role.role_name)
            .update_all(:user_role_id => user_role.id)
         
         GroupLeader.joins(:group => :enterprise)
          .where(:groups => {:enterprise_id => enterprise.id})
          .where(:role => user_role.role_name)
          .update_all(:user_role_id => user_role.id)
       end
    end
    
    # remove the now unused columns
    remove_column :users,         :role, :string
    remove_column :group_leaders, :role, :string
  end
  
  # hopefully we won't have to run the down migration but we need to set it up
  # just in case. unfortunately, all users will have to basic permissions if 
  # the down migration is run
  
  def down
    add_column  :users,         :role, :string  
    add_column  :group_leaders, :role, :string
    
    # update the role on users and group leaders
    Enterprise.find_each do |enterprise|
       enterprise.user_roles.find_each do |user_role|
         enterprise.users
            .where(:user_role_id => user_role.id)
            .update_all(:role => user_role.role_name.downcase.parameterize('_'))
         
         GroupLeader.joins(:group => :enterprise)
          .where(:groups => {:enterprise_id => enterprise.id})
          .where(:user_role_id => user_role.id)
          .update_all(:role => user_role.role_name.downcase.parameterize('_'))
       end
    end
    
    remove_reference :users,            :user_role
    remove_reference :group_leaders,    :user_role
  end
end
