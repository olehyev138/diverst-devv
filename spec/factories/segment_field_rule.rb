FactoryBot.define do
  factory :segment_field_rule do
    segment
    field
    operator SegmentFieldRule.operators[:equals]
    data ['abc'].to_json
  end
end
