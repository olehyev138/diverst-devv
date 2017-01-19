class AddGroupsToInitiatives < ActiveRecord::Migration
  def change
    change_table :initiatives do |t|
      t.integer :owner_group_id
    end

    create_table :initiative_participating_groups do |t|
      t.integer :initiative_id
      t.integer :group_id
    end
  end
end
