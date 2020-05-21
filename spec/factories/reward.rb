FactoryBot.define do
  factory :reward do
    association :enterprise
    points 100
    label { Faker::Lorem.word + 'reward' }
    picture_file_name { 'reward.png' }
    picture_content_type { 'image/png' }
    picture_file_size { 1024 }
    picture_updated_at { Time.now }

    after(:build) do |reward|
      reward.responsible = build(:user, enterprise: reward.enterprise)
    end
  end
end
