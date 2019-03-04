FactoryBot.define do
  factory :campaigns_group do
    association :campaign
    association :group
  end
end
