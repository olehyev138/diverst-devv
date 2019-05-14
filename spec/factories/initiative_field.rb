FactoryBot.define do
  factory :initiative_field do
    association :initiative, factory: :initiative
    association :field, factory: :field
  end
end
