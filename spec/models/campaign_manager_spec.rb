require 'rails_helper'

RSpec.describe CampaignsManager, type: :model do
  let!(:campaigns_manager) { build_stubbed(:campaigns_manager) }

  it { expect(campaigns_manager).to belong_to(:campaign) }
  it { expect(campaigns_manager).to belong_to(:user) }
end
