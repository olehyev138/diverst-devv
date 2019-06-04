class AddIndexToActiveOnUsers < ActiveRecord::Migration[5.1]
  def change
    add_index :users, :active
  end
end
