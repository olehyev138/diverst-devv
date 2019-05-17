class AddTimestampsForInitiativeUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :initiative_users, :created_at, :datetime, null: false
    add_column :initiative_users, :updated_at, :datetime, null: false
  end
end
