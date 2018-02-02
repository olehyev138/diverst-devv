class CreateFolders < ActiveRecord::Migration
  def up
    create_table :folders do |t|
      t.belongs_to  :container, polymorphic: true, index: true
      t.string      :name
      t.timestamps  null: false
    end
    
    create_table :folder_shares do |t|
      t.belongs_to  :container, polymorphic: true, index: true
      t.references :folder
      t.timestamps  null: false
    end
  end
  
  def down
    drop_table :folders
    drop_table :folder_shares
  end
end
