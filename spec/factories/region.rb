FactoryBot.define do
  factory :region do
    # specs wont pass without this - specifically line 133 - group_spec.rb
    id { Faker::Number.between(1, 10000000) }
    name { Faker::Lorem.sentence(3) }
    association :parent, factory: :group
  end
end
