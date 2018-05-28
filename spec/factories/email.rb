FactoryGirl.define do
  factory :email do
    name 'Awesome Email'
    subject { Faker::Lorem.sentence }
    content { Faker::Lorem.sentence }
    description { Faker::Lorem.sentence }
    mailer_name {"test_mailer"}
    mailer_method {"notification"}
  end
end
