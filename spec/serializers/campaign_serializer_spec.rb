require 'rails_helper'

RSpec.describe CampaignSerializer, type: :serializer do
  it 'returns fields for campaign' do
    campaign = create(:campaign, image: File.new('spec/fixtures/files/verizon_logo.png'), banner: File.new('spec/fixtures/files/verizon_logo.png'))
    create_list(:question, 3, campaign: campaign)
    serializer = CampaignSerializer.new(campaign)

    expect(serializer.serializable_hash[:image_location]).to_not be nil
    expect(serializer.serializable_hash[:banner_location]).to_not be nil
    expect(serializer.serializable_hash[:groups].empty?).to_not be true
    expect(serializer.serializable_hash[:questions].empty?).to_not be true
  end
end
