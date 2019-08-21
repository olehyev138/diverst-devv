class UsersSegmentSerializer < ApplicationRecordSerializer
  attributes :id, :user_id, :segment_id

  belongs_to :user
  belongs_to :segment
end
