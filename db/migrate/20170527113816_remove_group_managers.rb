class RemoveGroupManagers < ActiveRecord::Migration
  def up
    drop_table :groups_managers
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
