require 'rails_helper'

RSpec.describe Segment, type: :model do
  describe 'when validating' do
    let(:segment){ build_stubbed(:segment) }

    it{ expect(segment).belong_to(:enterprise) }
    it{ expect(segment).belong_to(:owner).class_name("User") }
    it{ expect(segment).to have_many(:rules).class_name("SegmentRule") }
    it{ expect(segment).to have_many(:user_segments) }
    it{ expect(segment).to have_many(:members).through(:users_segments).class_name("User").source(:user).dependent(:destroy) }
    it{ expect(segment).to have_many(:polls_segments) }
    it{ expect(segment).to have_many(:polls).through(:polls_segments) }
    it{ expect(segment).to have_many(:events_segments) }
    it{ expect(segment).to have_many(:events).through(:events_segments) }
    it{ expect(segment).to have_many(:group_messages_segments) }
    it{ expect(segment).to have_many(:group_messages).through(:group_messages_segments) }
    it{ expect(segment).to have_many(:invitation_segments_groups) }
    it{ expect(segment).to have_many(:groups).through(:invitation_segments_groups).inverse_of(:invitation_segments) }
    it{ expect(segment).to have_many(:initiative_segments) }
    it{ expect(segment).to have_many(:initiatives).through(:initiative_segments) }
  end
end
