FactoryBot.define do
  factory :policy_group_template do
    name { Faker::Lorem.sentence(3) }
    association :user_role, factory: :user_role
    enterprise
  end
end
