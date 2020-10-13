class GroupMessageCommentSerializer < ApplicationRecordSerializer
  attributes :permissions, :author

  def serialize_all_fields
    true
  end
end
