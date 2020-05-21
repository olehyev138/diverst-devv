FactoryBot.define do
  factory :mentoring_request_interest do
    association :mentoring_interest,  factory: :mentoring_interest
    association :mentoring_request,   factory: :mentoring_request
  end
end
