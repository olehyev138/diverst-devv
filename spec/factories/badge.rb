FactoryGirl.define do
  factory :badge do
    label { Faker::Lorem.sentence }
    points 100
    association :enterprise

    image_file_name { 'reward.png' }
    image_content_type { 'image/png' }
    image_file_size { 1024 }
  end
end
