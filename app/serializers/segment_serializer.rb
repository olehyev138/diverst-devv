class SegmentSerializer < ApplicationRecordSerializer
  attributes :owner, :all_rules_count, :active_users_filter, :limit, :permissions

  has_many :field_rules
  has_many :order_rules
  has_many :group_rules

  def serialize_all_fields
    true
  end
end
