FactoryGirl.define do
  factory :budget do
    subject { FactoryGirl.create(:group) }
    description { Faker::Lorem.sentence }

    factory :approved_budget do
      after(:create) do |budget|
        budget.approve!
      end
    end

    after(:create) do |budget|
      create_list(:budget_item, 3, budget: budget)
    end
  end
end
