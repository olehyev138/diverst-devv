class AddOutlookIdToUserInitiative < ActiveRecord::Migration
  def change
    add_column :initiative_users, :outlook_id, :string
  end
end
