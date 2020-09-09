FactoryBot.define do
  factory :suggested_hire do
    user nil
    group nil
    email { Faker::Internet.email }
    name { Faker::Internet.name }
  end
end
