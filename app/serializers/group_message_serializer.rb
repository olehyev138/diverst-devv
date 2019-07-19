class GroupMessageSerializer < ApplicationRecordSerializer
  attributes :group, :owner, :comments_count, :comments

  def serialize_all_fields
    true
  end
end
