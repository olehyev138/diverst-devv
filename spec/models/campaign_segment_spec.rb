require 'rails_helper'

RSpec.describe CampaignsSegment, type: :model do
  let!(:campaign_segment) { build_stubbed(:campaigns_segment) }

  it { expect(campaign_segment).to belong_to :campaign }
  it { expect(campaign_segment).to belong_to :segment }
end
