class GroupSerializer < ApplicationRecordSerializer
  attributes :id, :name, :short_description, :description, :pending_users, :members_visibility, :messages_visibility,
             :annual_budget, :leftover_money, :active, :parent_id, :latest_news_visibility, :upcoming_events_visibility, :private,
             :home_message, :default_mentor_group, :position, :group_category, :group_category_type, :news_feed, :enterprise_id,
             :logo_location, :banner_location, :annual_budget

  has_many :children
end
