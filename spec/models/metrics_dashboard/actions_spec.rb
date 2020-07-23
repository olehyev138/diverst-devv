require 'rails_helper'

RSpec.describe MetricsDashboard::Actions, type: :model do
  describe 'build' do
    let!(:user) { create(:user) }
    let!(:group) { create(:group) }

    it 'builds' do
      params = { metrics_dashboard: { name: 'test', group_ids: [group.id] } }
      expect(MetricsDashboard.build(Request.create_request(user), params).owner_id).to eq user.id
    end
  end
end
