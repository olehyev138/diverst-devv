FactoryGirl.define do
  factory :policy_group_template do
    association :enterprise, factory: :enterprise
  end
end
