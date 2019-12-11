FactoryBot.define do
  factory :reward do
    association :enterprise
    points 100
    label { Faker::Lorem.word + 'reward' }

    after(:build) do |reward|
      reward.responsible = build(:user, enterprise: reward.enterprise)
    end

    transient do
      picture_file { Pathname.new("#{Rails.root}/spec/fixtures/files/verizon_logo.png") }

      after(:build) do |reward, evaluator|
        reward.picture.attach(
          io: evaluator.picture_file.open,
          filename: evaluator.picture_file.basename.to_s
        )
      end
    end
  end
end
