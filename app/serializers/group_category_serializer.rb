class GroupCategorySerializer < ApplicationRecordSerializer
  attributes :group_category_type, :total_groups, :groups

  def serialize_all_fields
    true
  end
end
