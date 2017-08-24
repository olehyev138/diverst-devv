require 'rails_helper'

RSpec.describe CampaignInvitation, type: :model do
  describe 'when validating' do
    let(:campaign_invitation) { build_stubbed(:campaign_invitation) }
    
    it { expect(campaign_invitation).to belong_to(:campaign) }
    it { expect(campaign_invitation).to belong_to(:user) }
  end
end
