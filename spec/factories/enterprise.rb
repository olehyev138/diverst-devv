FactoryGirl.define do
  factory :enterprise do
    name { Faker::Company.name }
    created_at { Date.today }
    cdo_name {Faker::Name.name}
    sponsor_media { File.new("#{Rails.root}/spec/support/fixtures/files/verizon_logo.png") }
    theme nil
  end
end
