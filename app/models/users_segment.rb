class UsersSegment < ActiveRecord::Base
  belongs_to :user
  belongs_to :segment
end
