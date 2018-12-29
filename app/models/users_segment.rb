class UsersSegment < BaseClass
  belongs_to :user
  belongs_to :segment
  
  # validations
  validates_uniqueness_of :user, scope: [:segment], :message => "is already a member of this segment"
  
end
