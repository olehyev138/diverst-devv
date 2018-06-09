FactoryGirl.define do
  factory :folder_share do
    association :container, factory: :enterprise
    association :folder, factory: :folder
  end
end
