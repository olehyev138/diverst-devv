class GroupSerializer < ApplicationRecordSerializer
  attributes :id, :name, :short_description, :description, :pending_users, :members_visibility, :messages_visibility,
             :annual_budget, :annual_budget_leftover, :active, :parent_id, :latest_news_visibility, :upcoming_events_visibility,
             :private, :home_message, :default_mentor_group, :position, :group_category, :group_category_type, :news_feed,
             :enterprise_id, :event_attendance_visibility, :calendar_color, :auto_archive,
             :current_user_is_member, :banner, :banner_file_name, :banner_data, :permissions

  has_many :children

  def policies
    [:show?, :events_view?, :is_a_member?, :is_a_pending_member?, :is_an_accepted_member?, :is_a_leader?]
  end

  def logo_location
    object.logo_location(default_style: instance_options.dig(:scope, :image_size)&.to_sym)
  end

  def banner
    AttachmentHelper.attachment_signed_id(object.banner)
  end

  def banner_file_name
    AttachmentHelper.attachment_file_name(object.banner)
  end

  def banner_data
    AttachmentHelper.attachment_data_string(object.banner)
  end

  def current_user_is_member
    scope&.dig(:current_user)&.is_member_of?(object)
  end
end
