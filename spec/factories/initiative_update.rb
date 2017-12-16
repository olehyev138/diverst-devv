FactoryGirl.define do
    factory :initiative_update do
    	association :owner, factory: :user
    	association :initiative
    	comments { Faker::Lorem.sentence }
    	data { Faker::Lorem.sentence }
    	report_date { Faker::Date.forward(2) }
    end
end
