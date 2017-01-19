class InitiativeSegment < ActiveRecord::Base
  belongs_to :initiative
  belongs_to :segment
end
