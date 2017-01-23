class AddEmailSentToPolls < ActiveRecord::Migration
  def change
    add_column :polls, :email_sent, :boolean, default: false, null: false
  end
end
