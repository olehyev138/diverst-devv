FactoryGirl.define do
  factory :mentoring_request do
    status { ["accepted", "pending", "rejected"].sample }
    notes { Faker::Lorem.sentence }
    association :sender,    factory: :user
    association :receiver,  factory: :user
  end
end
