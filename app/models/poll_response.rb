class PollResponse < ActiveRecord::Base
  include ContainsFields

  belongs_to :poll
  belongs_to :employee
end
