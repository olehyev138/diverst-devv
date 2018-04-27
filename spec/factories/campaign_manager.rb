FactoryGirl.define do
	factory :campaigns_manager do
		association :campaign, factory: :campaign
		association :user, factory: :user
	end
end