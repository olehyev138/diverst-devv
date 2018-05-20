after :enterprise do
  enterprise = Enterprise.last

  # create the default emails with subject line and content
  emails = enterprise.emails.create!(
    [
      # user_group_mailer
      {
        :enterprise => enterprise,
        :name => "Group Notification Mailer", 
        :mailer_name => "user_group_mailer",
        :mailer_method => "notification",
        :content => "<p>Hello %{user.name},</p>\r\n\r\n<p>A new item has been posted to a Diversity and Inclusion group you are a member of. Select the link(s) below to access Diverst and review the item(s)</p>\r\n", 
        :subject => "You have updates in your %{custom_text.erg_text}", 
        :description => "Email that goes out to a members of a group when a news link or group message has been posted",
        :template => ""
      },
      # approve_request_mailer
      {
        :enterprise => enterprise,
        :name => "Approve Budget Mailer", 
        :mailer_name => "budget_mailer",
        :mailer_method => "approve_request",
        :content => "<p>Hello %{user.name},</p>\r\n\r\n<p>You have received a request to approve a budget for: %{group.name}</p>\r\n\r\n<p>%{click_here} to provide a review of the budget request.</p>\r\n", 
        :subject => "You are asked to review budget for %{group.name} %{custom_text.erg_text}", 
        :description => "Email that goes out to an approved manager after a budget is created",
        :template => ""
      },
      # budget_approved_mailer
      {
        :enterprise => enterprise,
        :name => "Budget Approved Mailer", 
        :mailer_name => "budget_mailer",
        :mailer_method => "budget_approved",
        :content => "<p>Hello %{user.name},</p>\r\n\r\n<p>Your budget request for: %{group.name}&nbsp;has been approved.</p>\r\n\r\n<p>%{click_here} to access your budget request.</p>\r\n", 
        :subject => "The budget for %{group.name} was approved", 
        :description => "Email that goes out to a budget requester after a budget has been approved",
        :template => ""
      },
      # budget_declined_mailer
      {
        :enterprise => enterprise,
        :name => "Budget Declined Mailer", 
        :mailer_name => "budget_mailer",
        :mailer_method => "budget_declined",
        :content => "<p>Hello %{user.name},</p>\r\n\r\n<p>Your budget request for: %{group.name}&nbsp;has been declined.</p>\r\n\r\n<p>%{click_here} to access your budget request.</p>\r\n", 
        :subject => "The budget for %{group.name} was declined", 
        :description => "Email that goes out to a budget requester after a budget has been declined",
        :template => ""
      },
      # campaign_mailer
      {
        :enterprise => enterprise,
        :name => "Campaign Mailer", 
        :mailer_name => "campaign_mailer",
        :mailer_method => "invitation",
        :content => "<p>Hello %{user.name},</p>\r\n\r\n<p>You are invited to join other members in the following online collaborative conversation in Diverst: %{campaign.title}</p>\r\n\r\n<p>%{campaign.link} to provide feedback and offer your thoughts and suggestions.</p>\r\n", 
        :subject => "You are invited to join %{group_names} in an online conversation in Diverst.", 
        :description => "Email that goes out to users after a campaign is created",
        :template => ""
      },
      # group_leader_post_notification_mailer
      {
        :enterprise => enterprise,
        :name => "Group Leader Posts Mailer", 
        :mailer_name => "group_leader_post_notification_mailer",
        :mailer_method => "notification",
        :content => "<p>Hello %{user.name},</p>\r\n\r\n<p>You have received a request to approve a posting for: %{group.name}.</p>\r\n\r\n<p>%{click_here} to provide approve/decline of this posting.</p>\r\n", 
        :subject => "%{count} Pending Post(s) for %{group.name}", 
        :description => "Email that goes out to group leaders after a new item is posted to the news feed",
        :template => ""
      },
      # poll_mailer
      {
        :enterprise => enterprise,
        :name => "Survey Mailer", 
        :mailer_name => "poll_mailer",
        :mailer_method => "invitation",
        :content => "<p>Hello %{user.name},</p>\r\n\r\n<p>You are invited to participate in the following online in Diverst: %{survey.title}</p>\r\n\r\n<p>%{click_here} to provide feedback and offer your thoughts and suggestions.</p>\r\n", 
        :subject => "You are Invited to participate in a '%{survey.title}' survey", 
        :description => "Email that goes out to users invited to participate in a survey/poll",
        :template => ""
      },
      # group_leader_member_notification_mailer
      {
        :enterprise => enterprise,
        :name => "Group Leader Member Notification Mailer", 
        :mailer_name => "group_leader_member_notification_mailer",
        :mailer_method => "notification",
        :content => "<p>Hello %{user.name},</p>\r\n\r\n<p>%{group.name} has %{count} pending member(s). Click below to view them and accept/deny group membership.</p>\r\n\r\n<p>%{click_here} to view pending members.</p>\r\n", 
        :subject => "%{count} Pending Member(s) for %{group.name}", 
        :description => "Email that goes out to group leaders when there are pending group members",
        :template => ""
      }
    ]
  )

  # create variables for enterprise 
  enterprise.email_variables.create!(
    [
      {:key => "user.name", :description => "Displays a user's name", :emails => emails, :example => "John Smith"},
      {:key => "group.name", :description => "Displays a group's name", :emails => emails, :example => "Women's Advisory Group"},
      {:key => "group_names", :description => "Displays an array of group names", :emails => emails, :example => "Women's Advisory Group, African Affinity Group"},
      {:key => "campaign.title", :description => "Displays a campaign's title", :emails => emails, :example => "Diversity Improvements"},
      {:key => "enterprise.id", :description => "Displays a enterprise's id", :emails => emails, :example => "20"},
      {:key => "enterprise.name", :description => "Displays a enterprise's name", :emails => emails, :example => "Microsoft"},
      {:key => "survey.title", :description => "Displays a survey's title", :emails => emails, :example => "What do you think of our group banner?"},
      {:key => "click_here", :description => "Displays a link to a resource or resources", :emails => emails, :example => "<a href=\"https://www.diverst.com\" target=\"_blank\">Click here</a>"},
      {:key => "custom_text.erg_text", :description => "Displays the enterprise's custom text for groups", :emails => emails, :example => "ERG"},
      {:key => "count", :description => "Displays a count", :emails => emails, :example => "4"}
    ]
  )
end