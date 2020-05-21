FactoryBot.define do
  factory :groups_metrics_dashboard do
    association :group
    association :metrics_dashboard
  end
end
