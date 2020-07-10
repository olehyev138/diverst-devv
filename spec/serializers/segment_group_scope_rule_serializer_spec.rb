require 'rails_helper'

RSpec.describe SegmentGroupScopeRuleSerializer, type: :serializer do
  it 'returns associations' do
    segment_group_scope_rule = create(:segment_group_scope_rule)
    serializer = SegmentGroupScopeRuleSerializer.new(segment_group_scope_rule, scope: serializer_scopes(create(:user)), scope_name: :scope)

    expect(serializer.serializable_hash[:id]).to eq(segment_group_scope_rule.id)
    expect(serializer.serializable_hash[:segment_id]).to eq(segment_group_scope_rule.segment_id)
  end
end
