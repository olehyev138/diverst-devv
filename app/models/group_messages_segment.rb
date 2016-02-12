class GroupMessagesSegment < ActiveRecord::Base
  belongs_to :group_message
  belongs_to :segment
  belongs_to :owner, class_name: "User"
end