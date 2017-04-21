FactoryGirl.define do
  factory :user_reward_action do
    association :user
    association :reward_action
    association :entity, factory: :initiative_user
    operation "add"
    points 0
  end
end
