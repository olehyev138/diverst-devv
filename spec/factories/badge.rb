FactoryBot.define do
  factory :badge do
    label { Faker::Lorem.sentence }
    points 100
    association :enterprise

    image_file_name { 'reward.png' }
    image_content_type { 'image/png' }
    image_file_size { 1024 }
    image_updated_at { Time.now }

    factory :badge_params do
      file = File.new(Rails.root + 'spec/fixtures/files/verizon_logo.png')
      image { Rack::Test::UploadedFile.new(file, 'image/png') }
    end
  end
end
