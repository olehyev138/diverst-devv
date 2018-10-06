FactoryGirl.define do
  factory :graph do
    association :field, factory: :field
    association :metrics_dashboard, factory: :metrics_dashboard
  end
end
