class AddNotificationsEmailToUsers < ActiveRecord::Migration[5.2]
  def change
  	add_column :users, :notifications_email, :string, after: :email
  end
end
