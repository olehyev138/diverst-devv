class AddOutlookIdToUserInitiative < ActiveRecord::Migration[5.2]
  def change
    add_column :initiative_users, :outlook_id, :string
  end
end
