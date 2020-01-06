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
end
