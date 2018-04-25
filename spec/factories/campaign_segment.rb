FactoryGirl.define do
	factory :campaigns_segment do
		association :campaign, factory: :campaign
		association :segment, factory: :segment
	end
end