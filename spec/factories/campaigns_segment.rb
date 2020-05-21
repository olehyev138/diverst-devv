FactoryBot.define do
  factory :campaigns_segment do
    association :campaign
    association :segment
  end
end
