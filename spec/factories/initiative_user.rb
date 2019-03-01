FactoryBot.define do
  factory :initiative_user do
    association :initiative
    association :user
  end
end
