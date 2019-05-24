FactoryBot.define do
  factory :group do
    transient do
      no_outcomes { false }
    end

    name { Faker::Lorem.sentence(3) }
    enterprise

    after(:create) do |group, evaluator|
      group.outcomes << create(:outcome, group: group) unless evaluator.no_outcomes
    end

    trait :without_outcomes do
      no_outcomes { true }
    end

    factory :group_with_users do
      transient do
        users_count 10
      end

      after(:create) do |group, evaluator|
        create_list(:user_group, evaluator.users_count, group: group, accepted_member: true)
      end
    end
  end
end
