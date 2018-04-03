FactoryGirl.define do
  factory :mentoring_request do
    status { ["accepted", "pending", "rejected"].sample }
    notes { Faker::Lorem.sentence }
    association :sender,    factory: :mentorship
    association :receiver,  factory: :mentorship
  end
end
