class AddTimestampAttributesToInitiativeComments < ActiveRecord::Migration[5.1]
  def change
  	add_column :initiative_comments, :created_at, :datetime, null: false
  	add_column :initiative_comments, :updated_at, :datetime, null: false
  end
end
