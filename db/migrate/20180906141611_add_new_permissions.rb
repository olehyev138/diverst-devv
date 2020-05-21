class AddNewPermissions < ActiveRecord::Migration
  def up
    add_column :policy_groups,          :manage_all, :boolean, :default => false
    add_column :policy_group_templates, :manage_all, :boolean, :default => false
    
    add_column :policy_groups,          :enterprise_manage, :boolean, :default => false
    add_column :policy_group_templates, :enterprise_manage, :boolean, :default => false
    
    add_column :policy_groups,          :groups_budgets_manage, :boolean, :default => false
    add_column :policy_group_templates, :groups_budgets_manage, :boolean, :default => false
    
    add_column :policy_groups,          :group_leader_index, :boolean, :default => false
    add_column :policy_group_templates, :group_leader_index, :boolean, :default => false
    
    add_column :policy_groups,          :groups_insights_manage, :boolean, :default => false
    add_column :policy_group_templates, :groups_insights_manage, :boolean, :default => false
    
    add_column :policy_groups,          :groups_layouts_manage, :boolean, :default => false
    add_column :policy_group_templates, :groups_layouts_manage, :boolean, :default => false
    
    add_column :policy_groups,          :group_resources_index, :boolean, :default => false
    add_column :policy_group_templates, :group_resources_index, :boolean, :default => false
    
    add_column :policy_groups,          :group_resources_create, :boolean, :default => false
    add_column :policy_group_templates, :group_resources_create, :boolean, :default => false
    
    add_column :policy_groups,          :group_resources_manage, :boolean, :default => false
    add_column :policy_group_templates, :group_resources_manage, :boolean, :default => false
    
    add_column :policy_groups,          :social_links_index, :boolean, :default => false
    add_column :policy_group_templates, :social_links_index, :boolean, :default => false
    
    add_column :policy_groups,          :social_links_create, :boolean, :default => false
    add_column :policy_group_templates, :social_links_create, :boolean, :default => false
    
    add_column :policy_groups,          :social_links_manage, :boolean, :default => false
    add_column :policy_group_templates, :social_links_manage, :boolean, :default => false
    
    add_column :policy_groups,          :group_settings_manage, :boolean, :default => false
    add_column :policy_group_templates, :group_settings_manage, :boolean, :default => false
    
    add_column :policy_groups,          :group_posts_index, :boolean, :default => false
    add_column :policy_group_templates, :group_posts_index, :boolean, :default => false
    
    add_column :policy_groups,          :mentorship_manage, :boolean, :default => false
    add_column :policy_group_templates, :mentorship_manage, :boolean, :default => false
    
    # we need to ensure group_leaders who are not 'admins' have access only to groups
    # where the role is permitted
    
    add_column :group_leaders, :initiatives_create,     :boolean, :default => false
    
    add_column  :group_leaders, :groups_budgets_request,  :boolean, :default => false
    
    add_column :group_leaders, :group_messages_manage,  :boolean, :default => false
    add_column :group_leaders, :group_messages_index,   :boolean, :default => false
    add_column :group_leaders, :group_messages_create,  :boolean, :default => false
    
    add_column :group_leaders, :news_links_index,      :boolean, :default => false
    add_column :group_leaders, :news_links_create,      :boolean, :default => false
    add_column :group_leaders, :news_links_manage,      :boolean, :default => false
    
    add_column :group_leaders, :social_links_index,      :boolean, :default => false
    add_column :group_leaders, :social_links_create,      :boolean, :default => false
    add_column :group_leaders, :social_links_manage,      :boolean, :default => false
    
    add_column :group_leaders, :group_leader_index,    :boolean, :default => false
    add_column :group_leaders, :group_leader_manage,    :boolean, :default => false
    
    add_column :group_leaders, :groups_members_index,  :boolean, :default => false
    add_column :group_leaders, :groups_members_manage,  :boolean, :default => false
    
    add_column :group_leaders, :groups_insights_manage,  :boolean, :default => false
    
    add_column :group_leaders, :groups_layouts_manage,  :boolean, :default => false
    
    add_column :group_leaders, :group_settings_manage,  :boolean, :default => false
    
    add_column :group_leaders, :group_resources_index,    :boolean, :default => false
    add_column :group_leaders, :group_resources_create,   :boolean, :default => false
    add_column :group_leaders, :group_resources_manage,   :boolean, :default => false
    
    add_column :group_leaders,  :group_posts_index, :boolean, :default => false
    
    remove_column :policy_groups,           :annual_budget_manage, :boolean 
    remove_column :policy_group_templates,  :annual_budget_manage, :boolean 
  end
  
  def down
    remove_column :policy_groups,          :manage_all, :boolean, :default => false
    remove_column :policy_group_templates, :manage_all, :boolean, :default => false
    
    remove_column :policy_groups,          :enterprise_manage, :boolean, :default => false
    remove_column :policy_group_templates, :enterprise_manage, :boolean, :default => false
    
    remove_column :policy_groups,          :groups_budgets_manage, :boolean, :default => false
    remove_column :policy_group_templates, :groups_budgets_manage, :boolean, :default => false
    
    remove_column :policy_groups,          :group_leader_index, :boolean, :default => false
    remove_column :policy_group_templates, :group_leader_index, :boolean, :default => false
    
    remove_column :policy_groups,          :groups_insights_manage, :boolean, :default => false
    remove_column :policy_group_templates, :groups_insights_manage, :boolean, :default => false
    
    remove_column :policy_groups,          :groups_layouts_manage, :boolean, :default => false
    remove_column :policy_group_templates, :groups_layouts_manage, :boolean, :default => false
    
    remove_column :policy_groups,          :group_resources_index, :boolean, :default => false
    remove_column :policy_group_templates, :group_resources_index, :boolean, :default => false
    
    remove_column :policy_groups,          :group_resources_create, :boolean, :default => false
    remove_column :policy_group_templates, :group_resources_create, :boolean, :default => false
    
    remove_column :policy_groups,          :group_resources_manage, :boolean, :default => false
    remove_column :policy_group_templates, :group_resources_manage, :boolean, :default => false
    
    remove_column :policy_groups,          :social_links_index, :boolean, :default => false
    remove_column :policy_group_templates, :social_links_index, :boolean, :default => false
    
    remove_column :policy_groups,          :social_links_create, :boolean, :default => false
    remove_column :policy_group_templates, :social_links_create, :boolean, :default => false
    
    remove_column :policy_groups,          :social_links_manage, :boolean, :default => false
    remove_column :policy_group_templates, :social_links_manage, :boolean, :default => false
    
    remove_column :policy_groups,          :group_settings_manage, :boolean, :default => false
    remove_column :policy_group_templates, :group_settings_manage, :boolean, :default => false
    
    remove_column :policy_groups,          :group_posts_index, :boolean, :default => false
    remove_column :policy_group_templates, :group_posts_index, :boolean, :default => false
    
    remove_column :policy_groups,          :mentorship_manage, :boolean, :default => false
    remove_column :policy_group_templates, :mentorship_manage, :boolean, :default => false
    
    # we need to ensure group_leaders who are not 'admins' have access only to groups
    # where the role is permitted
    
    remove_column :group_leaders, :initiatives_create,     :boolean, :default => false
    
    remove_column  :group_leaders, :groups_budgets_request,  :boolean, :default => false
    
    remove_column :group_leaders, :group_messages_manage,  :boolean, :default => false
    remove_column :group_leaders, :group_messages_index,   :boolean, :default => false
    remove_column :group_leaders, :group_messages_create,  :boolean, :default => false
    
    remove_column :group_leaders, :news_links_index,      :boolean, :default => false
    remove_column :group_leaders, :news_links_create,      :boolean, :default => false
    remove_column :group_leaders, :news_links_manage,      :boolean, :default => false
    
    remove_column :group_leaders, :social_links_index,      :boolean, :default => false
    remove_column :group_leaders, :social_links_create,      :boolean, :default => false
    remove_column :group_leaders, :social_links_manage,      :boolean, :default => false
    
    remove_column :group_leaders, :group_leader_index,    :boolean, :default => false
    remove_column :group_leaders, :group_leader_manage,    :boolean, :default => false
    
    remove_column :group_leaders, :groups_members_index,  :boolean, :default => false
    remove_column :group_leaders, :groups_members_manage,  :boolean, :default => false
    
    remove_column :group_leaders, :groups_insights_manage,  :boolean, :default => false
    
    remove_column :group_leaders, :groups_layouts_manage,  :boolean, :default => false
    
    remove_column :group_leaders, :group_settings_manage,  :boolean, :default => false
    
    remove_column :group_leaders, :group_resources_index,    :boolean, :default => false
    remove_column :group_leaders, :group_resources_create,   :boolean, :default => false
    remove_column :group_leaders, :group_resources_manage,   :boolean, :default => false
    
    remove_column :group_leaders,  :group_posts_index, :boolean, :default => false
    
    add_column :policy_groups,          :annual_budget_manage, :boolean, :default => false
    add_column :policy_group_templates, :annual_budget_manage, :boolean, :default => false
  end
end
