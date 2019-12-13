FactoryBot.define do
  factory :badge do
    label { Faker::Lorem.sentence }
    points 100
    association :enterprise

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
