FactoryGirl.define do
  factory :initiative do |f|
    f.name { Faker::Lorem.sentence }
    f.description { Faker::Lorem.sentence }
    f.location { Faker::Address.city }
    f.start { Faker::Time.between(Date.today, 1.month.from_now) }
    f.end { Faker::Time.between(1.month.from_now, 2.months.from_now)}
    f.estimated_funding { 0 }
    f.owner_group { FactoryGirl.create(:group) }
    f.pillar { owner_group.try(:pillars).try(:first) }
    f.owner {FactoryGirl.create(:user)}
    trait :with_budget_item do
      budget_item { FactoryGirl.create(:budget_item) }
      owner_group { budget_item.budget.subject }
      estimated_funding { rand(1..budget_item.available_amount ) }
    end
  end
end
