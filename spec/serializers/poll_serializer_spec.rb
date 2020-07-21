require 'rails_helper'

RSpec.describe PollSerializer, type: :serializer do
  it 'returns associations' do
    enterprise = create(:enterprise)
    group = create(:group, enterprise: enterprise)
    segment = create(:segment, enterprise: enterprise)
    poll = create(:poll, enterprise: enterprise, group_ids: [group.id], segment_ids: [segment.id])

    serializer = PollSerializer.new(poll, scope: serializer_scopes(create(:user)))

    expect(serializer.serializable_hash[:id]).to eq(poll.id)
    expect(serializer.serializable_hash[:groups].empty?).to be false
    expect(serializer.serializable_hash[:segments].empty?).to be false
    expect(serializer.serializable_hash[:fields].empty?).to be false
    field = serializer.serializable_hash[:fields].first
    expect(field[:type]).to_not be nil
  end
end
