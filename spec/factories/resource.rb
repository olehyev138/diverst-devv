FactoryBot.define do
  factory :resource do
    title { Faker::Lorem.sentence(3) }
    # file_file_name { 'test.csv' }
    # file_content_type { 'application/pdf' }
    # file_file_size { 1024 }
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
      # file = File.new(Rails.root + 'spec/fixtures/files/verizon_logo.png')
      # file_file_name { file.path }
      # file_content_type { 'image/png' }
      # file_file_size { file.size }
    end
  end
end
