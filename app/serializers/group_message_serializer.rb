class GroupMessageSerializer < ApplicationRecordSerializer
  attributes :owner, :comments_count

  has_many :comments

  def serialize_all_fields
    true
  end
end
