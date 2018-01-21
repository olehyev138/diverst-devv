class AddEnablePendingCommentsToEnterprises < ActiveRecord::Migration
  def change
    # allow admins to set a toggle for comments
    add_column :enterprises, :enable_pending_comments, :boolean, :default => false
    
    # toggle for comments
    add_column :answer_comments, :approved, :boolean, :default => false
    add_column :group_message_comments, :approved, :boolean, :default => false
    add_column :news_link_comments, :approved, :boolean, :default => false
  end
end
