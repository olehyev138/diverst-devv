class GroupMessageSerializer < ApplicationRecordSerializer
  attributes :group, :owner, :comments_count

  def serialize_all_fields
    true
  end
end
