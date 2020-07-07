require 'rails_helper'

RSpec.describe Activity, type: :model do
  describe 'when validating' do
    let(:activity) { build_stubbed(:activity) }

    it { expect(activity).to belong_to(:owner).class_name('User') }
  end

  describe 'test scopes' do
    context '.for_group_ids' do
      let!(:user1) { create(:user) }
      let!(:user2) { create(:user) }
      let!(:user3) { create(:user) }
      let!(:group1) { create(:group, id: 1) }
      before do
        create(:user_group, user: user1, group_id: group1.id)
        create(:user_group, user: user2, group: create(:group, id: 2))
        create(:user_group, user: user3, group_id: group1.id)
        create(:activity, owner: user1)
        create(:activity, owner: user2)
        create(:activity, owner: user3)
      end

      it 'returns logs for group ids' do
        expect(Activity.for_group_ids([1]).count).to eq 2
      end
    end

    context '.joined_from' do
      let!(:activity) { create(:activity) }

      it 'returns logs join from' do
        expect(Activity.joined_from(Date.yesterday)).to eq([activity])
      end
    end

    context '.joined_to' do
      let!(:activity) { create(:activity) }

      it 'returns logs join to' do
        expect(Activity.joined_to(Date.tomorrow)).to eq([activity])
      end
    end
  end
end
