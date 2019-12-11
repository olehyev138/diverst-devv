require 'rails_helper'

RSpec.describe SponsorSerializer, type: :serializer do
  it 'returns all fields and group' do
    group = create(:group)
    sponsor = create(:sponsor, sponsorable_id: group.id, sponsorable_type: 'Group', sponsor_media: { io: File.open('spec/fixtures/files/verizon_logo.png'), filename: 'file.png' })
    serializer = SponsorSerializer.new(sponsor)

    expect(serializer.serializable_hash[:id]).to_not be nil
    expect(serializer.serializable_hash[:group]).to_not be nil
    expect(serializer.serializable_hash[:sponsor_media_location]).to_not be nil
    expect(serializer.serializable_hash[:enterprise]).to be nil
  end

  it 'returns all fields and enterprise' do
    enterprise = create(:enterprise)
    sponsor = create(:sponsor, sponsorable_id: enterprise.id, sponsorable_type: 'Enterprise', sponsor_media: { io: File.open('spec/fixtures/files/verizon_logo.png'), filename: 'file.png' })
    serializer = SponsorSerializer.new(sponsor)

    expect(serializer.serializable_hash[:id]).to_not be nil
    expect(serializer.serializable_hash[:group]).to be nil
    expect(serializer.serializable_hash[:sponsor_media_location]).to_not be nil
    expect(serializer.serializable_hash[:enterprise]).to_not be nil
  end
end
