class PollsSegment < ActiveRecord::Base
  belongs_to :poll
  belongs_to :segment
end
