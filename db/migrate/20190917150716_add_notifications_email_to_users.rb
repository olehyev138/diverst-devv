class AddNotificationsEmailToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :notifications_email, :string, after: :email
  end
end
