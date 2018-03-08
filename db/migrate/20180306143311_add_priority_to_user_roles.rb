class AddPriorityToUserRoles < ActiveRecord::Migration
  def up
    add_column :user_roles, :priority, :integer, :unique => true, :null => false, :auto_increment => true
    
    # update all user_roles and set the priorities
    Enterprise.find_each do |enterprise|
      priority = 0
      enterprise.user_roles.find_each do |user_role|
        user_role.priority = priority
        user_role.save!
        priority += 1
      end
    end
  end
  
  def down
    remove_column :user_roles, :priority, :integer
  end
end
