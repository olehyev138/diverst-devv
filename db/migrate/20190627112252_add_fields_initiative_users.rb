class AddFieldsInitiativeUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :initiative_users, :attended,      :boolean, :default => false
    add_column :initiative_users, :check_in_time, :datetime
  end
end
