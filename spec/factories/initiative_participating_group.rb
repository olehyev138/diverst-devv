FactoryBot.define do
  factory :initiative_participating_group do
    association :initiative
    association :group
  end
end
