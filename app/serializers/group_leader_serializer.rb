class GroupLeaderSerializer < ApplicationRecordSerializer
  attributes :user_role, :position_name, :pending_member_notifications_enabled,
             :pending_comments_notifications_enabled, :pending_posts_notifications_enabled,
             :default_group_contact, :user

  def serialize_all_fields
    true
  end
end
