class AddEmailFieldsToEnterprises < ActiveRecord::Migration
  def change
    # cannot set default value for blob/text fields in MYSQL
    add_column :enterprises, :user_group_mailer_notification_text, :text
    add_column :enterprises, :campaign_mailer_notification_text, :text
    add_column :enterprises, :approve_budget_request_mailer_notification_text, :text
    add_column :enterprises, :poll_mailer_notification_text, :text
    add_column :enterprises, :budget_approved_mailer_notification_text, :text
    
    # update enterprise
    Enterprise.update_all(:user_group_mailer_notification_text => "<p>Hello %{user_name},</p>\r\n\r\n<p>A new item has been posted to a Diversity and Inclusion group you are a member of. Select the link(s) below to access Diverst and review the item(s)</p>\r\n")
    Enterprise.update_all(:campaign_mailer_notification_text => "<p>Hello %{user_name},</p>\r\n\r\n<p>You are invited to join other members in the following online collaborative conversation in Diverst: %{campaign_name}</p>\r\n\r\n<p>%{join_now} to provide feedback and offer your thoughts and suggestions.</p>\r\n")
    Enterprise.update_all(:approve_budget_request_mailer_notification_text => "<p>Hello %{user_name},</p>\r\n\r\n<p>You have received a request to approve a budget for: %{budget_name}</p>\r\n\r\n<p>%{click_here} to provide a review of the budget request.</p>\r\n")
    Enterprise.update_all(:poll_mailer_notification_text => "<p>Hello %{user_name},</p>\r\n\r\n<p>You are invited to participate in the following online in Diverst: %{survey_name}</p>\r\n\r\n<p>%{click_here} to provide feedback and offer your thoughts and suggestions.</p>\r\n")
    Enterprise.update_all(:budget_approved_mailer_notification_text => "<p>Hello %{user_name},</p>\r\n\r\n<p>Your budget request for: %{budget_name}&nbsp;has been approved.</p>\r\n\r\n<p>%{click_here} to access your budget request.</p>\r\n")
  end
end
