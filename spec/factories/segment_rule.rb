FactoryBot.define do
  factory :segment_rule do
    segment
    field
    operator SegmentRule.operators[:equals]
    values ['abc'].to_json
  end
end
