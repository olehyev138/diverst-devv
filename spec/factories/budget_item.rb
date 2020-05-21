FactoryBot.define do
  factory :budget_item do
    budget { FactoryBot.create(:approved_budget) }

    title { Faker::Lorem.sentence }
    estimated_amount { rand(100..1000) }
    available_amount { "#{estimated_amount}" }
    estimated_date { Faker::Date.between(Date.today, 1.year.from_now) }
    is_done { false }

    trait :done do
      is_done { true }
    end
  end
end
