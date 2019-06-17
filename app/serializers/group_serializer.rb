class GroupSerializer < ActiveModel::Serializer
  attributes :id, :enterprise_id, :name, :description, :created_at, :updated_at, :logo_file_name, :logo_content_type, :logo_file_size,
             :logo_updated_at, :send_invitations, :participation_score_7days, :yammer_create_group, :yammer_group_created, :yammer_group_name,
             :yammer_sync_users, :yammer_group_link, :yammer_id, :manager_id, :owner_id, :lead_manager_id, :pending_users, :members_visibility,
             :messages_visibility, :annual_budget, :leftover_money, :banner_file_name, :banner_content_type, :banner_file_size, :banner_updated_at,
             :calendar_color, :total_weekly_points, :active, :parent_id, :sponsor_image_file_name, :sponsor_image_content_type,
             :sponsor_image_file_size, :sponsor_image_updated_at, :company_video_url, :latest_news_visibility, :upcoming_events_visibility,
             :group_category_id, :group_category_type_id, :private, :short_description, :layout, :home_message, :default_mentor_group,
             :position, :expiry_age_for_news, :expiry_age_for_resources, :expiry_age_for_events, :unit_of_expiry_age, :auto_archive
end
