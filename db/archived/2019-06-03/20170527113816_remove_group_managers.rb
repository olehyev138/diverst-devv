class RemoveGroupManagers < ActiveRecord::Migration[5.1]
  def up
    drop_table :groups_managers
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
