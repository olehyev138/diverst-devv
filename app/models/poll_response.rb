class PollResponse < ActiveRecord::Base
  belongs_to :poll
  belongs_to :employee
end
