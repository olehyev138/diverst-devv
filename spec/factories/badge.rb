FactoryBot.define do
  factory :badge do
    label { Faker::Lorem.sentence }
    points 100
    association :enterprise

    # Paperclip
    #    image_file_name { 'reward.png' }
    #    image_content_type { 'image/png' }
    #    image_file_size { 1024 }
    #    image_updated_at { Time.now }

    factory :badge_params do
      #      file = File.new(Rails.root + 'spec/fixtures/files/verizon_logo.png')
      #      image { Rack::Test::UploadedFile.new(file, 'image/png') }
    end

    transient do
      image_file { Pathname.new("#{Rails.root}/spec/fixtures/files/trophy_image.jpg") }

      after(:build) do |badge, evaluator|
        badge.image.attach(
          io: evaluator.image_file.open,
          filename: evaluator.image_file.basename.to_s
        )
      end
    end
  end
end
