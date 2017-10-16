require 'rails_helper'

RSpec.describe GroupLeader, type: :model do
  describe 'when validating' do
    let(:group_leader) { build_stubbed(:group_leader) }

    it{ expect(group_leader).to validate_presence_of(:position_name) }
    it{ expect(group_leader).to belong_to(:user) }
    it{ expect(group_leader).to belong_to(:group) }
  end
  
  describe 'notifications_enabled_status'do
    it 'returns Off' do
      group_leader = create(:group_leader)
      expect(group_leader.notifications_enabled_status).to eq("Off")
    end
    
    it 'returns On' do
      group_leader = create(:group_leader, :notifications_enabled => true)
      expect(group_leader.notifications_enabled_status).to eq("On")
    end
  end
end
