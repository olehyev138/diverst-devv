FactoryBot.define do
  factory :user_reward do
    association :user
    association :reward
    points 0
  end
end
