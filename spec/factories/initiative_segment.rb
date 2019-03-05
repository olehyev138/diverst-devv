FactoryBot.define do
  factory :initiative_segment do
    association :initiative
    association :segment
  end
end
