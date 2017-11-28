FactoryGirl.define do
   # SPONSOR_MEDIA ||= File.open(Rails.root.join('spec/fixtures/files/verizon_logo.png'))
  factory :group do
    name { Faker::Lorem.sentence(3) }
    sponsor_name { Faker::Name.name }
    sponsor_title { Faker::Name.title }
    sponsor_message ""
    # sponsor_media Rack::Test::UploadedFile.new SPONSOR_MEDIA
    company_video_url { Faker::Internet.url }
    enterprise

    factory :group_with_users do
      transient do
        users_count 10
      end

      after(:create) do |group, evaluator|
        create_list(:user_group, evaluator.users_count, group: group, accepted_member: true)
      end
    end

    trait :with_outcomes do
      after(:create) do |group|
        group.outcomes << create(:outcome, group: group)
      end
    end
  end
end
