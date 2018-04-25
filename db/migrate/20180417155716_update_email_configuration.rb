class UpdateEmailConfiguration < ActiveRecord::Migration
  def change
    # remove any existing emails, email variables
    Email.destroy_all
    EmailVariable.destroy_all
    
    # add columns
    add_column :emails, :content,       :text,    :null => false
    add_column :emails, :mailer_name,   :string,  :null => false
    add_column :emails, :mailer_method, :string,  :null => false
    add_column :emails, :template,      :string
    add_column :emails, :description,   :string,  :null => false
    
    create_table :enterprise_email_variables do |t|
      t.references  :enterprise
      t.string      :key
      t.string      :description
      t.timestamps null: false
    end
    
    add_reference :email_variables, :enterprise_email_variable
    
    add_column :email_variables, :downcase,       :boolean, :default => false
    add_column :email_variables, :upcase,         :boolean, :default => false
    add_column :email_variables, :titleize,       :boolean, :default => false
    add_column :email_variables, :pluralize,      :boolean, :default => false
    
    
    Email.reset_column_information
    EmailVariable.reset_column_information
          
    Enterprise.find_each do |enterprise|
      # create the default emails with subject line and content
      enterprise.emails.create!(
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
          }
        ]
      )

      emails = enterprise.emails
      
      # create variables for enterprise 
      enterprise.email_variables.create!(
        [
          {:key => "user.name", :description => "Displays a user's name", :emails => emails},
          {:key => "group.name", :description => "Displays a group's name", :emails => emails},
          {:key => "group_name", :description => "Displays an array of group names", :emails => emails},
          {:key => "campaign.title", :description => "Displays a campaign's title", :emails => emails},
          {:key => "group_name", :description => "Displays an array of group names", :emails => emails},
          {:key => "enterprise.id", :description => "Displays a enterprise's id", :emails => emails},
          {:key => "enterprise.name", :description => "Displays a enterprise's name", :emails => emails},
          {:key => "survey.title", :description => "Displays a survey's title", :emails => emails},
          {:key => "click_here", :description => "Displays a link to a resource or resources", :emails => emails},
          {:key => "custom_text.erg_text", :description => "Displays the enterprise's custom text for groups", :emails => emails}
        ]
      )
    end
    
    # # remove columns
    remove_column :emails, :slug,                 :string
    remove_column :emails, :custom_html_template, :string
    remove_column :emails, :custom_txt_template,  :string
    remove_column :emails, :use_custom_templates, :boolean
    
    remove_column :email_variables, :key,         :string
    remove_column :email_variables, :description, :string
    remove_column :email_variables, :required,    :boolean
    
    remove_column :enterprises, :user_group_mailer_notification_text,             :text
    remove_column :enterprises, :campaign_mailer_notification_text,               :text
    remove_column :enterprises, :approve_budget_request_mailer_notification_text, :text
    remove_column :enterprises, :poll_mailer_notification_text,                   :text
    remove_column :enterprises, :budget_approved_mailer_notification_text,        :text
    remove_column :enterprises, :budget_declined_mailer_notification_text,        :text
    remove_column :enterprises, :group_leader_post_mailer_notification_text,      :text
  end
end
