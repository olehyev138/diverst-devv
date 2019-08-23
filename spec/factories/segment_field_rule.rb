FactoryBot.define do
  factory :segment_field_rule do
    segment
    field
    operator Field::OPERATORS[:equals]
    data ['abc'].to_json
  end
end
