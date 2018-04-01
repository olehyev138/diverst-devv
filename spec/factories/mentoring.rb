FactoryGirl.define do
  factory :mentoring do
    association :mentee, factory: :mentorship
    association :mentor, factory: :mentorship
  end
end
