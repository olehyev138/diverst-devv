class GroupLeaderSerializer < ApplicationRecordSerializer
  has_one :group
  has_one :user
  has_one :user_role
end
