FactoryGirl.define do
  factory :user, aliases: [:owner] do
    email { generate(:email_address) }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    password 'f4k3p455w0rd'
    invitation_created_at Time.current
    invitation_sent_at Time.current
    invitation_accepted_at Time.current
    enterprise
    role "admin"
    provider "email"

    after(:create) do |user|
      user.policy_group = create(:policy_group)
    end
  end
end
