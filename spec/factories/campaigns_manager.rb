FactoryBot.define do
  factory :campaigns_manager do
    association :campaign
    association :user
  end
end
