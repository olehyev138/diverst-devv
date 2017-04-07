FactoryGirl.define do
  factory :user_reward_action do
    association :user
    association :reward_action
  end
end
