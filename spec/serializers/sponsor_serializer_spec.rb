require 'rails_helper'

RSpec.describe SponsorSerializer, type: :serializer do
  let(:group) { create(:group) }
  let(:group_sponsor) { create(:sponsor, sponsorable_id: group.id, sponsorable_type: 'Group', sponsor_media: { io: File.open('spec/fixtures/files/verizon_logo.png'), filename: 'file.png' }) }
  let(:group_sponsor_serializer) { SponsorSerializer.new(group_sponsor, scope: serializer_scopes(create(:user))) }

  let(:enterprise) { create(:enterprise) }
  let(:enterprise_sponsor) { create(:sponsor, sponsorable_id: enterprise.id, sponsorable_type: 'Enterprise', sponsor_media: { io: File.open('spec/fixtures/files/verizon_logo.png'), filename: 'file.png' }) }
  let(:enterprise_sponsor_serializer) { SponsorSerializer.new(enterprise_sponsor, scope: serializer_scopes(create(:user))) }

  include_examples 'permission container', :group_sponsor_serializer
  include_examples 'permission container', :enterprise_sponsor_serializer

  it 'returns all fields and group' do
    serializer = group_sponsor_serializer
    expect(serializer.serializable_hash[:id]).to_not be nil
    expect(serializer.serializable_hash[:group]).to_not be nil
    expect(serializer.serializable_hash[:sponsor_media_location]).to_not be nil
    expect(serializer.serializable_hash[:enterprise]).to be nil
  end

  it 'returns all fields and enterprise' do
    serializer = enterprise_sponsor_serializer
    expect(serializer.serializable_hash[:id]).to_not be nil
    expect(serializer.serializable_hash[:group]).to be nil
    expect(serializer.serializable_hash[:sponsor_media_location]).to_not be nil
    expect(serializer.serializable_hash[:enterprise]).to_not be nil
  end
end
