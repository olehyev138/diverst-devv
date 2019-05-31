FactoryBot.define do
  factory :session do
    user
    token { Faker::Alphanumeric.alphanumeric 15 }
    expires_at { Faker::Date.forward(5) }
  end
end
