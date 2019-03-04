FactoryBot.define do
  factory :campaign_invitation do
    association :campaign
    association :user
  end
end
