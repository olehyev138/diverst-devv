after 'development:enterprise' do
  spinner = TTY::Spinner.new(":spinner Populating enterprises with email templates...", format: :spin_2)
  spinner.run do |spinner|
    Enterprise.all.each do |enterprise|
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
            :content => "<p>Hello %{user.name},</p>\r\n\r\n<p>You are invited to join other members in the following online collaborative conversation in Diverst: %{campaign.title}</p>\r\n\r\n<p>%{click_here} to provide feedback and offer your thoughts and suggestions.</p>\r\n", 
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
          },
          # welcome_mailer
          {
            :enterprise => enterprise,
            :name => 'Welcome Mailer',
            :mailer_name => 'welcome_mailer',
            :mailer_method => 'notification',
            :subject => "Hi %{user.name} and welcome to %{group.name}.",
            :content => "<p>Hello %{user.name},</p>\r\n\r\n<p>Welcome as a new member of %{group.name}! %{click_here} to check our page often for latest news and messages and look forward to seeing you at our events!.</p>\r\n",
            :description => "Email that goes out to new group members",
            :template => ""
          },
          #user_onboarding_mailer
          {
            :name => "User Onboarding Mailer", 
            :mailer_name => "diverst_mailer",
            :mailer_method => "invitation_instructions",
            :content => "<p>Welcome to Diverst!</p>\r\n\r\n<p>At Diverst, we embrace our differences. Diversity in all of its forms is key to our firm&rsquo;s open culture and long-term success. We believe that a diverse workforce where varying perspectives and backgrounds collaborate, will ultimately produce better results for our employees, business and investors.</p>\r\n\r\n<p><strong>That is why we are so excited to introduce you to Diverst, a community-based program focused on bringing together our unique experiences, backgrounds and perspectives to impact a greater ONE. While ONE firm, we are made of many distinctive parts that together influence innovation, performance, and thought leadership. Building and maintaining a diverse culture of belonging is a shared responsibility &ndash; from employees to senior leaders. As ONE, we will leverage the firm&rsquo;s full potential by promoting and supporting activities that celebrate diversity and develop an awareness of inclusion throughout our organization.</strong></p>\r\n\r\n<p>Via your Diverst ONE community portal, you can learn about the latest news and events related to inclusion and diversity, as well as participate in our Employee Resource Group program (ERGs).</p>\r\n\r\n<p>%{click_here} to get started by building your profile and checking out all the different ways you can get involved. You can also access your Portal via the link on the top navigation bar of the Intranet Homepage.</p>\r\n\r\n<p>If you have any questions or need assistance, please contact info@diverst.com.</p>\r\n", 
            :subject => "Invitation Instructions", 
            :description => "Email that goes out to users after they've been added.",
            :template => ""
          },
          #survey_response_mailer
          {
            :name => "Poll Response Notification Mailer", 
            :mailer_name => "poll_response_mailer",
            :mailer_method => "notification",
            :content => "<p>Hello %{user.name},</p>\r\n\r\n<p>This is to confirm that your response to our survey has been received. Thank you for your participtaion!</p>", 
            :subject => "Thank you for participating in our '%{survey.title} survey", 
            :description => "Email that goes out to users after they have submitted a response to a survey.",
            :template => ""
          }, 
          #campaign_response_mailer
          {
            :name => "Campaign Response Notification Mailer",
            :mailer_name => "campaign_response_mailer",
            :mailer_method => "notification",
            :content => "<p>Thank you for submitting an idea to %{campaign.title} campaign. Your idea response is being evaluated now.<p>Sincerely, %{sponsor} Sponsor</p></p>",
            :subject => "Thank you for participating in our %{campaign.title} campaign",
            :description => "Email that goes out to users after they have submitted an idea.",
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
          {:key => "campaign.title", :description => "Displays a campaign's title", :emails => emails, :example => "Innovative Ideas for COVID-19"},          
          {:key => "sponsor_name", :description => "Displays a sponsor's name", :emails => emails, :example => "Elon Musk"},
          {:key => "answer.title", :description => "Displays title of idea", :emails => emails, :example => "Global Warming Solution"},
          {:key => "click_here", :description => "Displays a link to a resource or resources", :emails => emails, :example => "<a href=\"https://www.diverst.com\" target=\"_blank\">Click here</a>"},
          {:key => "custom_text.erg_text", :description => "Displays the enterprise's custom text for groups", :emails => emails, :example => "ERG"},
          {:key => "count", :description => "Displays a count", :emails => emails, :example => "4"}
        ]
      )
    end
    spinner.success("[DONE]")
  end
end