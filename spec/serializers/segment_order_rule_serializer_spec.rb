require 'rails_helper'

RSpec.describe SegmentOrderRuleSerializer, type: :serializer do
  it 'returns associations' do
    segment_order_rule = create(:segment_order_rule)
    serializer = SegmentOrderRuleSerializer.new(segment_order_rule, scope: serializer_scopes(create(:user)), scope_name: :scope)

    expect(serializer.serializable_hash[:id]).to eq(segment_order_rule.id)
    expect(serializer.serializable_hash[:segment_id]).to eq(segment_order_rule.segment_id)
    expect(serializer.serializable_hash[:field]).to eq(segment_order_rule.field)
    expect(serializer.serializable_hash[:operator]).to eq(segment_order_rule.operator)
  end
end
