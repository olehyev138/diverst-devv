class GroupMessagesSegment < ActiveRecord::Base
  belongs_to :group_message
  belongs_to :segment
end