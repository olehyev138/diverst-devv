class AddIndexToActiveOnUsers < ActiveRecord::Migration
  def change
    add_index :users, :active
  end
end
