class PollsSegment < ApplicationRecord
  belongs_to :poll
  belongs_to :segment
end
