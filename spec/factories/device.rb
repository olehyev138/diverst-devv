FactoryBot.define do
  factory :device do
    token Faker::Alphanumeric.alphanumeric 10
    user
  end
end
