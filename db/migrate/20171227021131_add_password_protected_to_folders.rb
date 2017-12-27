class AddPasswordProtectedToFolders < ActiveRecord::Migration
  def change
    add_column :folders, :password_protected, :boolean, :default => false
    add_column :folders, :password_digest, :string, :null => true
  end
end
