class GroupMessageSerializer < ApplicationRecordSerializer
  attributes :group, :owner, :comments_count

  has_many :comments

  def serialize_all_fields
    true
  end
end
