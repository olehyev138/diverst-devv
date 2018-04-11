class AddEmailFieldsToEnterprises < ActiveRecord::Migration
  def change
    # cannot set default value for blob/text fields in MYSQL
    add_column :enterprises, :user_group_mailer_notification_text, :text
    Enterprise.update_all(:user_group_mailer_notification_text => "<p>Hello %{user_name},</p>\r\n\r\n<p>A new item has been posted to a Diversity and Inclusion group you are a member of. Select the link(s) below to access Diverst and review the item(s)</p>\r\n")
  end
end
