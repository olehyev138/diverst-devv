FactoryBot.define do
  factory :folder_share do
    association :enterprise, factory: :enterprise
    association :folder, factory: :folder
  end
end
