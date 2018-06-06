class UpdatePermissionsWorkflow < ActiveRecord::Migration
  def up
    # add role to users
    add_column :users, :custom_policy_group,  :boolean, :null => false, :default => false
    
    # create user_roles
    create_table :user_roles do |t|
      t.references :enterprise,             index: true, foreign_key: true
      # default role for enterprise - can never be deleted
      t.boolean :default,                   default: false
      t.string :role_name,                  :null => true
      t.string :role_type,                  :null => true,  :default => "non_admin"
      t.timestamps                          null: false
    end
    
    # add user_role id to users and group leaders so we can maintain the same name
    # and track the user role by ID
    add_reference :users,         :user_role
    add_reference :group_leaders, :user_role
    
    # create policy_group_templates
    create_table :policy_group_templates do |t|
      t.string :name,                       :null => false
      # default policy_group_template for enterprise - can never be deleted
      t.boolean :default,                   default: false
      t.belongs_to :user_role
      t.belongs_to :enterprise
      
      t.boolean :campaigns_index,           default: false
      t.boolean :campaigns_create,          default: false
      t.boolean :campaigns_manage,          default: false

      t.boolean :polls_index,               default: false
      t.boolean :polls_create,              default: false
      t.boolean :polls_manage,              default: false

      t.boolean :events_index,              default: false
      t.boolean :events_create,             default: false
      t.boolean :events_manage,             default: false

      t.boolean :group_messages_index,      default: false
      t.boolean :group_messages_create,     default: false
      t.boolean :group_messages_manage,     default: false

      t.boolean :groups_index,              default: false
      t.boolean :groups_create,             default: false
      t.boolean :groups_manage,             default: false
      
      t.boolean :groups_members_index,      default: false
      t.boolean :groups_members_manage,     default: false
      
      t.boolean :groups_budgets_index,      default: false
      t.boolean :groups_budgets_request,    default: false
      t.boolean :groups_budgets_approve,    default: false

      t.boolean :metrics_dashboards_index,  default: false
      t.boolean :metrics_dashboards_create, default: false

      t.boolean :news_links_index,          default: false
      t.boolean :news_links_create,         default: false
      t.boolean :news_links_manage,         default: false

      t.boolean :enterprise_resources_index, default: false
      t.boolean :enterprise_resources_create, default: false
      t.boolean :enterprise_resources_manage, default: false

      t.boolean :segments_index,          default: false
      t.boolean :segments_create,         default: false
      t.boolean :segments_manage,         default: false

      t.boolean :users_index,             default: false
      t.boolean :users_manage,            default: false
      
      t.boolean :initiatives_index,       default: false
      t.boolean :initiatives_create,      default: false
      t.boolean :initiatives_manage,      default: false
      
      t.boolean :logs_view,               default: false
      t.boolean :annual_budget_manage,    default: false
      t.boolean :branding_manage,         default: false
      
      t.boolean :sso_manage,              default: false
      t.boolean :permissions_manage,      default: false
      t.boolean :group_leader_manage,     default: false
      
      t.boolean :global_calendar,         default: false
      t.boolean :manage_posts,            default: false
      t.boolean :diversity_manage,        default: false
      
      t.timestamps null: false
    end
    
    # add new permissions/user_id to policy_groups
    add_column :policy_groups, :sso_manage,             :boolean, :default => false
    add_column :policy_groups, :permissions_manage,     :boolean, :default => false
    add_column :policy_groups, :diversity_manage,       :boolean, :default => false
    add_column :policy_groups, :manage_posts,           :boolean, :default => false
    add_column :policy_groups, :group_leader_manage,    :boolean, :default => false
    add_column :policy_groups, :global_calendar,        :boolean, :default => false
    add_column :policy_groups, :groups_budgets_approve, :boolean, :default => false
    add_column :policy_groups, :branding_manage,        :boolean, :default => false
    add_column :policy_groups, :user_id,                :integer, :null => true
    
    # update policy_groups table
    change_table :policy_groups do |t|
      t.remove :name, :default_for_enterprise, :enterprise_id, :admin_pages_view, :global_settings_manage
    end
    
    remove_column  :users, :policy_group_id, :integer
    
    add_column :user_roles, :priority, :integer, :null => false, :auto_increment => true
    
    # update the role id on users and group leaders
    Enterprise.find_each do |enterprise|
      
      # create default enterprise user roles
      enterprise.user_roles.create!(
        [
          {:role_name => "Admin",                 :role_type => "admin",  :priority => 0},
          {:role_name => "Diversity Manager",     :role_type => "admin",  :priority => 1},
          {:role_name => "National Manager",      :role_type => "admin",  :priority => 2},
          {:role_name => "Group Leader",          :role_type => "group",  :priority => 3},
          {:role_name => "Group Treasurer",       :role_type => "group",  :priority => 4},
          {:role_name => "Group Content Creator", :role_type => "group",  :priority => 5},
          {:role_name => "User",                  :role_type => "user",   :priority => 6, :default => true,}
        ]
      )
      
      enterprise.users.update_all(:user_role_id => enterprise.default_user_role)
         
      # create basic policy group for each user
      enterprise.users.find_each do |user|
        user.set_default_policy_group
      end
         
      group_leader_role_id = enterprise.user_roles.where(:role_type => "group").order(:priority).first.id
         
      GroupLeader.joins(:group)
      .where(:groups => {:enterprise_id => enterprise.id})
      .update_all(:user_role_id => group_leader_role_id)
    end
  end
  
  def down
    # remove columns that were added
    remove_reference :users,            :user_role
    remove_reference :group_leaders,    :user_role
    
    remove_column :users, :custom_policy_group, :boolean
    
    remove_column :policy_groups, :sso_manage,              :boolean
    remove_column :policy_groups, :permissions_manage,      :boolean
    remove_column :policy_groups, :diversity_manage,        :boolean
    remove_column :policy_groups, :manage_posts,            :boolean
    remove_column :policy_groups, :group_leader_manage,     :boolean
    remove_column :policy_groups, :global_calendar,         :boolean
    remove_column :policy_groups, :groups_budgets_approve,  :boolean
    remove_column :policy_groups, :user_id,                 :integer
    remove_column :policy_groups, :branding_manage,         :boolean
    
    # remove tables that were created
    drop_table :user_roles
    drop_table :policy_group_templates
    
    # add columns/references
    add_column  :policy_groups, :name,                    :string,  :null => false
    add_column  :policy_groups, :default_for_enterprise,  :boolean, :default => false
    add_column  :policy_groups, :admin_pages_view,        :boolean, :default => false
    add_column  :policy_groups, :global_settings_manage,  :boolean, :default => false
    
    add_column  :users, :policy_group_id, :integer
    
    add_reference :policy_groups, :enterprise
  end
end
