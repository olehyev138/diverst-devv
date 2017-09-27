FactoryGirl.define do
  factory :user do
    email { generate(:email_address) }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    password 'f4k3p455w0rd'
    invitation_created_at Time.current
    invitation_sent_at Time.current
    invitation_accepted_at Time.current
    enterprise
    policy_group
    provider "email"
  end
end
