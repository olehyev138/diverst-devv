FactoryBot.define do
  factory :segment_order_rule do
    segment
    operator SegmentOrderRule.operators[SegmentOrderRule.operators.keys.sample]
    field SegmentOrderRule.fields[SegmentOrderRule.fields.keys.sample]
  end
end
