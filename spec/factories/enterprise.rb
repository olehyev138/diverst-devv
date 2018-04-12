FactoryGirl.define do
  factory :enterprise do
    name { Faker::Company.name }
    created_at { Date.today }
    cdo_name {Faker::Name.name}
    theme nil
    user_group_mailer_notification_text {"Hello %{user_name}, a new item has been posted to a Diversity and Inclusion group you are a member of.  Select the link(s) below to access Diverst and review the item(s)"}
    campaign_mailer_notification_text {"<p>Hello %{user_name},</p>\r\n\r\n<p>You are invited to join %{group_names} in an online conversation in Diverst!</p>\r\n\r\n<p>%{join_now} to provide feedback and offer your thoughts and suggestions.</p>\r\n"}
  end
end
