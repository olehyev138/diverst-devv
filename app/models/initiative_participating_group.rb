class InitiativeParticipatingGroup < ActiveRecord::Base
  belongs_to :initiative
  belongs_to :group
end
