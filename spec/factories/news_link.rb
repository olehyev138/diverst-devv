FactoryBot.define do
  factory :news_link do
    title 'New link'
    description { Faker::Lorem.sentence(3) }
    url { Faker::Internet.url }
    association :author, factory: :user
    association :group, factory: :group_with_users

    factory :news_link_with_picture do
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
end
