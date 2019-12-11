FactoryBot.define do
  factory :resource do
    title { Faker::Lorem.sentence(3) }
    url { Faker::Internet.url('example.com') }
    association :folder, factory: :folder_with_group

    factory :resource_with_file do
      title { Faker::Lorem.sentence(3) }
      association :folder, factory: :folder_with_group

      transient do
        file_file { Pathname.new("#{Rails.root}/spec/fixtures/files/verizon_logo.png") }

        after(:build) do |resource, evaluator|
          resource.file.attach(
            io: evaluator.file_file.open,
            filename: evaluator.file_file.basename.to_s
          )
        end
      end
    end
  end
end
