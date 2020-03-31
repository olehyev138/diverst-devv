class GroupCategoryTypeSerializer < ApplicationRecordSerializer
  attributes :name

  has_many :group_categories

  def serialize_all_fields
    true
  end
end
