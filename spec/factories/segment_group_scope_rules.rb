FactoryBot.define do
  factory :segment_group_scope_rule do
    segment
    operator SegmentGroupScopeRule.operators[SegmentGroupScopeRule.operators.keys.sample]

    after(:build) do |segment_group_scope_rule|
      segment_group_scope_rule.segment_group_scope_rule_groups = build_list(:segment_group_scope_rule_group,
                                                                            rand(1..3),
                                                                            segment_group_scope_rule: segment_group_scope_rule)
    end
  end
end
