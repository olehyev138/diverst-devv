class AddExampleToEnterpriseEmailVariables < ActiveRecord::Migration
  def change
    add_column :enterprise_email_variables, :example, :text
    
    EnterpriseEmailVariable.where(:key => "user.name").update_all(:example => "John Smith")
    EnterpriseEmailVariable.where(:key => "group.name").update_all(:example => "Women's Advisory Group")
    EnterpriseEmailVariable.where(:key => "group_names").update_all(:example => "Women's Advisory Group, African Affinity Association")
    EnterpriseEmailVariable.where(:key => "campaign.title").update_all(:example => "Diverst Recruiting")
    EnterpriseEmailVariable.where(:key => "enterprise.id").update_all(:example => "20")
    EnterpriseEmailVariable.where(:key => "enterprise.name").update_all(:example => "Microsoft")
    EnterpriseEmailVariable.where(:key => "survey.title").update_all(:example => "Weekly Survey")
    EnterpriseEmailVariable.where(:key => "click_here").update_all(:example => "<a href=\"https://www.diverst.com\" target=\"_blank\">Click here</a>")
    EnterpriseEmailVariable.where(:key => "custom_text.erg_text").update_all(:example => "Inclusion Network")
    EnterpriseEmailVariable.where(:key => "count").update_all(:example => "4") if EnterpriseEmailVariable.where(:key => "count").count > 0
    
    if EnterpriseEmailVariable.where(:key => "count").count < 1
      Enterprise.find_each do |enterprise|
        enterprise.email_variables.create!(:key => "count", :example => "4", :description => "Display a count of resources")
      end
    end
    
    Enterprise.find_each do |enterprise|
      # create the default email for pending group notification
      enterprise.emails.create!(
        [
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
      # get the email
      email = enterprise.emails.last
      
      enterprise.email_variables.find_each do |variable|
        variable.emails << email
      end
    end
    
  end
end
