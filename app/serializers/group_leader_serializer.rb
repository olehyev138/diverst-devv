class GroupLeaderSerializer < ApplicationRecordSerializer
  attributes :group, :user_role, :position_name, :pending_member_notifications_enabled,
             :pending_comment_notifications_enabled, :pending_posts_notifications_enabled,
             :default_group_contact

  belongs_to :user

  def serialize_all_fields
    true
  end
end
