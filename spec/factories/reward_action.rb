FactoryBot.define do
  factory :reward_action do
    label { Faker::Lorem.sentence(3) }
    key { Faker::Lorem.sentence(1) }
  end
end
