FactoryGirl.define do
  factory :mentoring_request do
    type { ["request", "proposal"].sample }
    status { ["accepted", "pending", "rejected"].sample }
    notes { Faker::Lorem.sentence }
  end
end
