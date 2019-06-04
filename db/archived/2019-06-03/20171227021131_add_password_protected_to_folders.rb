class AddPasswordProtectedToFolders < ActiveRecord::Migration[5.1]
  def change
    add_column :folders, :password_protected, :boolean, :default => false
    add_column :folders, :password_digest, :string, :null => true
  end
end
