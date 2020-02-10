require 'rails_helper'

RSpec.describe UsersHelper do
  let!(:enterprise) { create(:enterprise) }
  let!(:user) { create(:user, enterprise: enterprise) }

  before do
    enterprise.update(enable_rewards: true)
    allow(helper).to receive(:current_user).and_return(user)
  end

  describe '#user_performance_label' do
    it 'returns a label for user performance' do
      expect(helper.user_performance_label(user)).to eq user.name_with_status + " (#{ user.total_weekly_points})"
    end
  end

  describe '#user_group_performance_label' do
    let!(:user_group) { create(:user_group, user_id: user.id, group_id: create(:group, enterprise: enterprise).id) }

    it 'returns a label for group performance' do
      expect(helper.user_group_performance_label(user_group)).to eq user_group.user.name_with_status + " (#{ user_group.total_weekly_points})"
    end
  end

  describe '#get_label' do
    it 'when user is in session' do
      expect(helper.get_label(user)).to eq user.name_with_status
    end

    it 'when user is not in session' do
      another_user = create(:user, enterprise: enterprise)
      expect(helper.get_label(another_user)).to eq (link_to another_user.name_with_status, another_user)
    end
  end
end
