class GroupMessageCommentSerializer < ApplicationRecordSerializer
  attributes :author

  def serialize_all_fields
    true
  end
end
