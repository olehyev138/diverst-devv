FactoryGirl.define do
  factory :enterprise do
    name { Faker::Company.name }
    created_at { Date.today }
    cdo_name {Faker::Name.name}
    theme nil
    user_group_mailer_notification_text {"Hello %{user_name}, a new item has been posted to a Diversity and Inclusion group you are a member of.  Select the link(s) below to access Diverst and review the item(s)"}
    campaign_mailer_notification_text {"<p>Hello %{user_name},</p>\r\n\r\n<p>You are invited to join other members in the following online collaborative conversation in Diverst: %{campaign_name}</p>\r\n\r\n<p>%{join_now} to provide feedback and offer your thoughts and suggestions.</p>\r\n"}
    approve_budget_request_mailer_notification_text {"<p>Hello %{user_name},</p>\r\n\r\n<p>You have received a request to approve a budget for: %{budget_name}</p>\r\n\r\n<p>%{click_here} to provide a review of the budget request.</p>\r\n"}
    poll_mailer_notification_text {"<p>Hello %{user_name},</p>\r\n\r\n<p>You are invited to participate in the following online in Diverst: %{survey_name}</p>\r\n\r\n<p>%{click_here} to provide feedback and offer your thoughts and suggestions.</p>\r\n"}
  end
end
