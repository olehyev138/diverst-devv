require 'rails_helper'

RSpec.describe CampaignSerializer, type: :serializer do
  let(:campaign) do
    create(
        :campaign,
        image: {
            io: File.open('spec/fixtures/files/verizon_logo.png'),
            filename: 'file.png'
        },
        banner: {
            io: File.open('spec/fixtures/files/verizon_logo.png'),
            filename: 'file.png'
        }
      )
  end
  let(:serializer) { CampaignSerializer.new(campaign, scope: serializer_scopes(create(:user))) }

  include_examples 'permission container', :serializer

  it 'returns fields for campaign' do
    create_list(:question, 3, campaign: campaign)

    expect(serializer.serializable_hash[:image_location]).to_not be nil
    expect(serializer.serializable_hash[:banner_location]).to_not be nil
    expect(serializer.serializable_hash[:groups].empty?).to_not be true
    expect(serializer.serializable_hash[:questions].blank?).to be true
  end

  include_examples 'preloads serialized data', :campaign
end
