FactoryGirl.define do
  factory :group do
    id { Faker::Number.between(1, 10000) }
    name { Faker::Lorem.sentence(3) }
    enterprise

    factory :group_with_users do
      transient do
        users_count 10
      end

      after(:create) do |group, evaluator|
        create_list(:user_group, evaluator.users_count, group: group, accepted_member: true)
      end
    end

    trait :with_outcomes do
      after(:create) do |group|
        group.outcomes << create(:outcome, group: group)
      end
    end
  end
end
