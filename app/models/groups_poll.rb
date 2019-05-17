class GroupsPoll < ApplicationRecord
  belongs_to :group
  belongs_to :poll
end
