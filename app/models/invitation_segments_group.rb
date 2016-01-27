class InvitationSegmentsGroup < ActiveRecord::Base
  belongs_to :invitation_segment
  belongs_to :group
end
