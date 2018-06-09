FactoryGirl.define do
	factory :groups_metrics_dashboard do
		association :group, factory: :group
		association :metrics_dashboard, factory: :metrics_dashboard
	end
end