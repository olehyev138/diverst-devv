FactoryBot.define do
  factory :update do
    association :owner, factory: :user
    association :updatable, factory: :group
    comments { Faker::Lorem.sentence }
    data { }
    report_date { Faker::Date.forward(2) }

    factory :initiative_update2 do
      association :updatable, factory: :initiative
    end

    factory :group_update2 do
      association :updatable, factory: :group
    end
  end

  factory :updatable, class: 'Group' do
    id { Faker::Number.between(1, 10000000) }
    name { Faker::Lorem.sentence(3) }

    enterprise
  end
end
