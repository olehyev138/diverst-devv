require 'rails_helper'

RSpec.describe GroupLeaderDecorator do
  describe '#enabled_status' do
    let!(:user) { create :user }
    let!(:group) { create :group, enterprise: user.enterprise }
    context 'when pending_member_notifications_enabled' do
      before { create(:user_group, user: user, group: group, accepted_member: true) }

      it 'returns off' do
        group_leader = create(:group_leader, user: user, group: group)
        decorated_group_leader = group_leader.decorate
        expect(decorated_group_leader.enabled_status(group_leader.pending_member_notifications_enabled)).to eq('Off')
      end

      it 'returns on' do
        group_leader = create(:group_leader, user: user, group: group, pending_member_notifications_enabled: true)
        decorated_group_leader = group_leader.decorate
        expect(decorated_group_leader.enabled_status(group_leader.pending_member_notifications_enabled)).to eq('On')
      end
    end
  end
end
