FactoryBot.define do
  factory :mentoring_request do
    status { 'pending' }
    notes { Faker::Lorem.sentence }
    association :enterprise, factory: :enterprise
    association :sender,    factory: :user
    association :receiver,  factory: :user

    factory :mentoring_request_skips_validate do
      to_create { |instance| instance.save(validate: false) }
    end
  end
end
