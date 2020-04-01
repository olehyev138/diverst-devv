FactoryBot.define do
  factory :outcome do
    name { Faker::Commerce.product_name }
    # association :group, factory: :group

    after(:create) do |outcome|
      create_list(:pillar, 3, outcome: outcome)
    end
  end
end
