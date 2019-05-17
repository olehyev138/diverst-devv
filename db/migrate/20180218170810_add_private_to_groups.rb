class AddPrivateToGroups < ActiveRecord::Migration[5.1]
  def change
    add_column :groups, :private, :boolean, :default => false
  end
end
