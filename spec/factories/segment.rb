FactoryBot.define do
  factory :segment do
    name { Faker::Lorem.sentence(3) }
    enterprise
    owner
    active_users_filter { Segment.active_users_filter.find_value(:both_active_and_inactive) }

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
        evaluator.field_rules create_list(:segment_rule, evaluator.rules_count, segment: segment)
      end
    end
  end
end
