class GroupsPoll < ActiveRecord::Base
  belongs_to :group
  belongs_to :poll
end
