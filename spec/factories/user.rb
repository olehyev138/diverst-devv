FactoryGirl.define do
  factory :user do
    email { generate(:email_address) }
    first_name 'Frank'
    last_name 'Marineau'
    password 'f4k3p455w0rd'
    invitation_created_at Time.current
    invitation_sent_at Time.current
    invitation_accepted_at Time.current
    enterprise
    policy_group
  end
end
