class GroupCategorySerializer < ApplicationRecordSerializer
  attributes :group_category_type

  def serialize_all_fields
    true
  end
end
