FactoryBot.define do
  factory :metrics_dashboard do
    enterprise
    name { Faker::Lorem.sentence(3) }
    groups { [create(:group)] }
    factory :metrics_dashboard_with_graphs do
      transient do
        graph_count 2
      end

      after(:create) do |metrics_dashboard, evaluator|
        evaluator.graphs create_list(:dashboard_graph, evaluator.graph_count, collection: metrics_dashboard)
      end
    end
  end
end
