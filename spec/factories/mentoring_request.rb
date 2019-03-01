FactoryBot.define do
  factory :mentoring_request do
    status { ["accepted", "pending", "rejected"].sample }
    notes { Faker::Lorem.sentence }
    association :enterprise,    factory: :enterprise
    association :sender,    factory: :user
    association :receiver,  factory: :user
  end
end
