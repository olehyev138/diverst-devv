FactoryBot.define do
  factory :mentoring_request do
    status { 'pending' }
    notes { Faker::Lorem.sentence }
    association :enterprise, factory: :enterprise
    association :sender,    factory: :user
    association :receiver,  factory: :user
  end
end
