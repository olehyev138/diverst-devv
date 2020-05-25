require 'rails_helper'

RSpec.describe VideoRoom, type: :model do
  let!(:enterprise) { create(:enterprise) }
  let(:room) { build(:video_room, enterprise_id: enterprise.id) }

  describe 'test associations' do
    it { expect(room).to belong_to(:enterprise) }
  end

  describe 'test validations' do
    it { expect(room).to validate_uniqueness_of(:sid).scoped_to(:enterprise_id) }
  end

  describe 'test instance method' do
    it 'billing for small group' do
      room.update participants: 2, duration: 10
      expect(room.billing).to eq(0.0027)
    end

    it 'billing for large group' do
      room.update participants: 20, duration: 10
      expect(room.billing).to eq(0.0667)
    end
  end
end
