FactoryGirl.define do
  factory :enterprise do
    name { Faker::Company.name }
    created_at { Date.today }
    cdo_name {Faker::Name.name}
    theme nil
    user_group_mailer_notification_text {"Hello %{user_name}, a new item has been posted to a Diversity and Inclusion group you are a member of.  Select the link(s) below to access Diverst and review the item(s)"}
  end
end
