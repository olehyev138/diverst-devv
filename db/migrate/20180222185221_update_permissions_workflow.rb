class UpdatePermissionsWorkflow < ActiveRecord::Migration
  def up
    # add role to users
    # add_column :users, :role,                 :string,  :null => false, :default => "user"
    # add_column :users, :custom_policy_group,  :boolean, :null => false, :default => false
    
    # # create user_roles
    # create_table :user_roles do |t|
    #   t.references :enterprise,             index: true, foreign_key: true
    #   # default role for enterprise - can never be deleted
    #   t.boolean :default,                   default: false
    #   t.string :role_name,                  :null => true
    #   t.string :role_type,                  :null => true,  :default => "non_admin"
    #   t.timestamps                          null: false
    # end
    
    # # create policy_group_templates
    # create_table :policy_group_templates do |t|
    #   t.string :name,                       :null => false
    #   # default policy_group_template for enterprise - can never be deleted
    #   t.boolean :default,                   default: false
    #   t.belongs_to :user_role
    #   t.belongs_to :enterprise
      
    #   t.boolean :campaigns_index,           default: false
    #   t.boolean :campaigns_create,          default: false
    #   t.boolean :campaigns_manage,          default: false

    #   t.boolean :polls_index,               default: false
    #   t.boolean :polls_create,              default: false
    #   t.boolean :polls_manage,              default: false

    #   t.boolean :events_index,              default: false
    #   t.boolean :events_create,             default: false
    #   t.boolean :events_manage,             default: false

    #   t.boolean :group_messages_index,      default: false
    #   t.boolean :group_messages_create,     default: false
    #   t.boolean :group_messages_manage,     default: false

    #   t.boolean :groups_index,              default: false
    #   t.boolean :groups_create,             default: false
    #   t.boolean :groups_manage,             default: false
      
    #   t.boolean :groups_members_index,      default: false
    #   t.boolean :groups_members_manage,     default: false
      
    #   t.boolean :groups_budgets_index,      default: false
    #   t.boolean :groups_budgets_request,    default: false
    #   t.boolean :groups_budgets_approve,    default: false

    #   t.boolean :metrics_dashboards_index,  default: false
    #   t.boolean :metrics_dashboards_create, default: false

    #   t.boolean :news_links_index,          default: false
    #   t.boolean :news_links_create,         default: false
    #   t.boolean :news_links_manage,         default: false

    #   t.boolean :enterprise_resources_index, default: false
    #   t.boolean :enterprise_resources_create, default: false
    #   t.boolean :enterprise_resources_manage, default: false

    #   t.boolean :segments_index,          default: false
    #   t.boolean :segments_create,         default: false
    #   t.boolean :segments_manage,         default: false

    #   t.boolean :users_index,             default: false
    #   t.boolean :users_manage,            default: false
      
    #   t.boolean :initiatives_index,       default: false
    #   t.boolean :initiatives_create,      default: false
    #   t.boolean :initiatives_manage,      default: false
      
    #   t.boolean :logs_view,               default: false
    #   t.boolean :annual_budget_manage,    default: false
    #   t.boolean :branding_manage,         default: false
      
    #   t.boolean :sso_manage,              default: false
    #   t.boolean :permissions_manage,      default: false
    #   t.boolean :group_leader_manage,     default: false
      
    #   t.boolean :global_calendar,         default: false
    #   t.boolean :manage_posts,            default: false
    #   t.boolean :diversity_manage,        default: false
      
    #   t.timestamps null: false
    # end
    
    # # add new permissions/user_id to policy_groups
    # add_column :policy_groups, :sso_manage,             :boolean, :default => false
    # add_column :policy_groups, :permissions_manage,     :boolean, :default => false
    # add_column :policy_groups, :diversity_manage,       :boolean, :default => false
    # add_column :policy_groups, :manage_posts,           :boolean, :default => false
    # add_column :policy_groups, :group_leader_manage,    :boolean, :default => false
    # add_column :policy_groups, :global_calendar,        :boolean, :default => false
    # add_column :policy_groups, :groups_budgets_approve, :boolean, :default => false
    # add_column :policy_groups, :branding_manage,        :boolean, :default => false
    # add_column :policy_groups, :user_id,                :integer, :null => true
    
    # add_column :group_leaders, :role, :string, :null => true
    
    # # update policy_groups table
    # change_table :policy_groups do |t|
    #   t.remove :name, :default_for_enterprise, :enterprise_id, :admin_pages_view, :global_settings_manage
    # end
    
    # remove_column  :users, :policy_group_id, :integer
    
    add_column :user_roles, :priority, :integer, :null => false, :auto_increment => true
    
    # get the enterprise
    Enterprise.find_each do |enterprise|
      # create default enterprise user roles
      enterprise.user_roles.create!(
        [
          {:role_name => "admin",                 :role_type => "admin"},
          {:role_name => "diversity_manager",     :role_type => "admin"},
          {:role_name => "national_manager",      :role_type => "admin"},
          {:role_name => "group_leader",          :role_type => "group"},
          {:role_name => "group_treasurer",       :role_type => "group"},
          {:role_name => "group_content_creator", :role_type => "group"},
          {:role_name => "user",                  :role_type => "user", :default => true}
        ]
      )
      
      # set everyone to have basic permissions to ensure proper migration
      # set basic user role for all users
      enterprise.users.update_all(:role => "user")
      
      # create basic policy group for each user
      enterprise.users.find_each do |user|
        user.set_default_policy_group
      end
    end
  end
  
  def down
    # remove columns that were added
    remove_column :users, :role,                :string
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
    
    remove_column :group_leaders, :role, :string
    
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
