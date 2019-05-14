require 'rails_helper'

RSpec.describe CampaignsGroup, type: :model do
  describe 'when validating' do
    let(:campaigns_group) { build_stubbed(:campaigns_group) }

    it { expect(campaigns_group).to belong_to(:campaign) }
    it { expect(campaigns_group).to belong_to(:group) }
  end
end
