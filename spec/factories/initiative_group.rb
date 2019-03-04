FactoryBot.define do
  factory :initiative_group do
    association :initiative
    association :group
  end
end
