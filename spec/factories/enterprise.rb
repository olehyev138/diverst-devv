FactoryGirl.define do
  factory :enterprise do
    name 'Hyperion'
    created_at { Time.current }

    theme nil
  end
end
