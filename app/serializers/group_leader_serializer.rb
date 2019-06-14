class GroupLeaderSerializer < ActiveModel::Serializer
  attributes :id, :group_id, :user_id, :position_name, :created_at, :updated_at, :visible, :pending_member_notifications_enabled,
             :pending_comments_notifications_enabled, :pending_posts_notifications_enabled, :default_group_contact, :user_role_id,
             :groups_budgets_index, :initiatives_manage, :groups_manage, :initiatives_create, :groups_budgets_request, :group_messages_manage,
             :group_messages_index, :group_messages_create, :news_links_index, :news_links_create, :news_links_manage, :social_links_index,
             :social_links_create, :social_links_manage, :group_leader_index, :group_leader_manage, :groups_members_index, :groups_members_manage,
             :groups_insights_manage, :groups_layouts_manage, :group_settings_manage, :group_resources_index, :group_resources_create,
             :group_resources_manage, :group_posts_index, :budget_approval, :groups_budgets_manage, :manage_posts, :initiatives_index, :position
end
