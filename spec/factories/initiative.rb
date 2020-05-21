FactoryBot.define do
  factory :initiative do |f|
    f.name { Faker::Lorem.sentence }
    f.description { Faker::Lorem.sentence }
    f.location { Faker::Address.city }
    f.start { Faker::Time.between(2.months.ago, Date.yesterday) }
    f.end { Faker::Time.between(32.days.from_now, 2.months.from_now) }
    f.estimated_funding { 0 }
    f.owner_group { FactoryBot.create(:group) }
    f.pillar { owner_group.try(:pillars).try(:first) }
    f.owner { FactoryBot.create(:user) }
    f.annual_budget { FactoryBot.create(:annual_budget) }
    trait :with_budget_item do
      budget_item { FactoryBot.create(:budget_item) }
      owner_group { budget_item.budget.group }
      estimated_funding { rand(1..budget_item.available_amount) }
    end
  end
end
