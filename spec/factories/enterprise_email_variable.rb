FactoryBot.define do
  factory :enterprise_email_variable do
    enterprise
    key { 'user.name' }
    description { "Display's a user's name" }
    example { 'John Smith' }
  end
end
