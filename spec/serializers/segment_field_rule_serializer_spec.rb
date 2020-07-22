require 'rails_helper'

RSpec.describe SegmentFieldRuleSerializer, type: :serializer do
  it 'returns associations' do
    segment_field_rule = create(:segment_field_rule)
    serializer = SegmentFieldRuleSerializer.new(segment_field_rule, scope: serializer_scopes(create(:user)))

    expect(serializer.serializable_hash[:id]).to eq(segment_field_rule.id)
    expect(serializer.serializable_hash[:segment_id]).to eq(segment_field_rule.segment_id)
    expect(serializer.serializable_hash[:field_id]).to eq(segment_field_rule.field_id)
    expect(serializer.serializable_hash[:permissions]).to be nil
  end
end
