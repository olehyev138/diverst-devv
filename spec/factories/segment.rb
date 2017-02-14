FactoryGirl.define do
  factory :segment do
    name { Faker::Lorem.sentence(3) }
    enterprise

    factory :segment_with_users do
      transient do
        users_count 10
      end

      after(:create) do |segment, evaluator|
        evaluator.members create_list(:user, evaluator.users_count, segments: [segment])
      end
    end

    factory :segment_with_rules do
      transient do
        rules_count 2
      end

      after(:create) do |segment, evaluator|
        evaluator.rules create_list(:segment_rule, evaluator.rules_count, segment: segment)
      end
    end
  end
end
