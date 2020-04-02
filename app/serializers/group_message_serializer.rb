class GroupMessageSerializer < ApplicationRecordSerializer
  attributes :comments_count

  has_one :owner
  has_many :comments

  def serialize_all_fields
    true
  end
end
