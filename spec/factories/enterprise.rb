FactoryGirl.define do
  # SPONSOR_MEDIA ||= File.open(Rails.root.join('spec/fixtures/files/verizon_logo.png'))
  factory :enterprise do
    name { Faker::Company.name }
    created_at { Date.today }
    cdo_name {Faker::Name.name}
    # sponsor_media Rack::Test::UploadedFile.new SPONSOR_MEDIA
    # company_video_url { Faker::Internet.url }
    theme nil
  end
end
