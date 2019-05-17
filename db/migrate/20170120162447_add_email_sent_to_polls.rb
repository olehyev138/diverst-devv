class AddEmailSentToPolls < ActiveRecord::Migration[5.1]
  def change
    add_column :polls, :email_sent, :boolean, default: false, null: false
  end
end
