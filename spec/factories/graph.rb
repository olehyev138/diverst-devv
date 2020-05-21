FactoryBot.define do
  factory :graph do
    association :field, factory: :field
    association :metrics_dashboard, factory: :metrics_dashboard

    trait :initialized_metrics_dashboard do
      initialize_with { new(metrics_dashboard: build(:metrics_dashboard)) }
    end

    factory :graph_with_metrics_dashboard, traits: [:initialized_metrics_dashboard]
  end
end
