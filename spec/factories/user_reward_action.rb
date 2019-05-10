FactoryBot.define do
  factory :user_reward_action do
    association :user
    association :reward_action
    association :initiative, factory: :initiative
    operation 'add'
    points 0
  end
end
