class AddEnablePendingCommentsToEnterprises < ActiveRecord::Migration
  def change
    add_column :enterprises, :enable_pending_comments, :boolean, :default => false
    add_column :answer_comments, :approved, :boolean, :default => true
    add_column :event_comments, :approved, :boolean, :default => true
    add_column :group_message_comments, :approved, :boolean, :default => true
    add_column :initiative_comments, :approved, :boolean, :default => true
    add_column :news_link_comments, :approved, :boolean, :default => true
  end
end
