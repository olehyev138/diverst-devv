FactoryBot.define do
  factory :news_link_photo do
    association :news_link

    transient do
      file_file { Pathname.new("#{Rails.root}/spec/fixtures/files/trophy_image.jpg") }

      after(:build) do |news_link_photo, evaluator|
        news_link_photo.file.attach(
          io: evaluator.file_file.open,
          filename: evaluator.file_file.basename.to_s
        )
      end
    end
  end
end
