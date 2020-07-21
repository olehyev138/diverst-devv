require 'rails_helper'

RSpec.describe SegmentSerializer, type: :serializer do
  it 'returns associations' do
    segment = create(:segment)
    serializer = SegmentSerializer.new(segment, scope: serializer_scopes(create(:user)))

    expect(serializer.serializable_hash[:id]).to_not be_nil
    expect(serializer.serializable_hash[:enterprise_id]).to_not be_nil
    expect(serializer.serializable_hash[:owner]).to_not be_nil
    expect(serializer.serializable_hash[:all_rules_count]).to_not be_nil
  end
end
