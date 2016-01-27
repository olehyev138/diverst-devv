class InvitationSegmentsGroup < ActiveRecord::Base
  belongs_to :invitation_segment, class_name: "Segment"
  belongs_to :group
end
