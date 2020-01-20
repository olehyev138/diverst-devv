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
    trait :with_budget_item do
      before(:create) do |initiative, evaluator|
        estimate_funding = initiative.estimated_funding

        if estimate_funding
          initiative.budget_item = create(:budget_item, estimated_amount: 2 * estimate_funding)
        else
          initiative.budget_item = create(:budget_item)
          initiative.estimated_funding = rand(1..initiative.budget_item.available_amount)
        end

        initiative.owner_group = initiative.budget_item.group
      end
    end
  end
end
