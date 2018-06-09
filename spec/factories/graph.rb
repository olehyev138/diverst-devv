FactoryGirl.define do
  factory :graph do
    association :field, factory: :field
    association :collection, factory: :metrics_dashboard
    # association :aggregation, factory: :graph_field

    #factory :dashboard_graph do
      #association :collection, factory: :metrics_dashboard
    #end

    #factory :poll_graph do
      #association :collection, factory: :poll
    #end
  end
end
