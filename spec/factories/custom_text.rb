FactoryBot.define do
  factory :custom_text do
    erg { Faker::Lorem.sentence(3) }
    program { Faker::Lorem.sentence(3) }
  end
end
