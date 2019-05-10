require 'rails_helper'

RSpec.describe InvitationSegmentsGroup, type: :model do
  let!(:invitation_segments_group) { build_stubbed(:invitation_segments_group) }

  it { expect(invitation_segments_group).to belong_to(:invitation_segment).class_name('Segment').with_foreign_key(:segment_id) }
  it { expect(invitation_segments_group).to belong_to(:group) }
end
