FactoryBot.define do
  factory :group do
    transient do
      no_outcomes { false }
    end

    # specs wont pass without this - specifically line 133 - group_spec.rb
    id { Faker::Number.between(1, 10000000) }

    name { Faker::Lorem.sentence(3) }
    enterprise

    after(:create) do |group, evaluator|
      group.outcomes << create(:outcome, group: group) unless evaluator.no_outcomes
    end

    trait :without_outcomes do
      no_outcomes { true }
    end

    trait :with_annual_budget do
      annual_budgets { FactoryBot.create_list(:annual_budget, 1, amount: 10000) }
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
