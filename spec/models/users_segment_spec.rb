require 'rails_helper'

RSpec.describe UsersSegment, type: :model do
  let(:users_segment) { build_stubbed(:users_segment) }

  describe 'test associations' do
    it { expect(users_segment).to belong_to(:user) }
    it { expect(users_segment).to belong_to(:segment) }

    it 'validates 1 user per segment' do
      segment_member = create(:user)
      segment = create(:segment)
      segment_member_1 = create(:users_segment, user: segment_member, segment: segment)
      segment_member_2 = build(:users_segment, user: segment_member, segment: segment)

      expect(segment_member_1.valid?).to be(true)
      expect(segment.valid?).to be(true)
      expect(segment_member_1.valid?).to be(true)

      # ensure the user cannot be added as a member to the same segment twice
      expect(segment_member_2.valid?).to be(false)
      expect(segment_member_2.errors.full_messages.first).to eq('User is already a member of this segment')
    end
  end

  describe 'elasticsearch methods' do
    context '#as_indexed_json' do
      let!(:object) { create(:users_segment) }

      it 'serializes the correct fields with the correct data' do
        hash = {
          'id' => object.id,
          'user_id' => object.user_id,
          'segment_id' => object.segment_id,
          'segment' => {
            'enterprise_id' => object.segment.enterprise_id,
            'name' => object.segment.name,
          },
          'user' => {
            'created_at' => object.user.created_at.beginning_of_hour,
            'enterprise_id' => object.user.enterprise_id,
          },
          'user_combined_info' => object.user_combined_info
        }
        expect(object.as_indexed_json).to eq(hash)
      end
    end
  end
end
