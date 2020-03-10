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
      before(:create) do |initiative, evaluator|
        estimate_funding = initiative.estimated_funding
        budget = create(
            :budget,
            estimated_amount: estimate_funding,
            annual_budget:
                create(
                    :annual_budget,
                    group: initiative.group,
                    amount: 3000 + estimate_funding * 5
                  )
          )

        initiative.budget_item = budget.budget_items.first
        budget.approve(initiative.owner)

        unless estimate_funding > 0
          initiative.estimated_funding = rand(1..initiative.budget_item.available_amount)
        end

        initiative.owner_group = initiative.budget_item.group
      end
    end
  end
end
