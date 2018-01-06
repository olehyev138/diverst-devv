FactoryGirl.define do
  factory :device do
    token { Faker::Crypto.md5 }
    association :user, factory: :user
    platform {"apple"}
  end
end
