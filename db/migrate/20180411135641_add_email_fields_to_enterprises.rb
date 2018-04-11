class AddEmailFieldsToEnterprises < ActiveRecord::Migration
  def change
    # cannot set default value fro blob/text fields in MYSQL
    add_column :enterprises, :user_group_mailer_notification_text, :text
    Enterprise.update_all(:user_group_mailer_notification_text => "Hello %{user_name}, a new item has been posted to a Diversity and Inclusion group you are a member of.  Select the link(s) below to access Diverst and review the item(s)")
  end
end
