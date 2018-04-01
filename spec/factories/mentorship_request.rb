FactoryGirl.define do
  factory :mentorship_request do
    association :mentorship,          factory: :mentorship
    association :mentoring_request,   factory: :mentoring_request
  end
end
