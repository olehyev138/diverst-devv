class InvitationSegmentsGroup < BaseClass
  belongs_to :invitation_segment, class_name: 'Segment', foreign_key: :segment_id
  belongs_to :group
end
