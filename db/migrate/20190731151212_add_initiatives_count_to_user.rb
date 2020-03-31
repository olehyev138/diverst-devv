class AddInitiativesCountToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :initiatives_count, :integer
  end
end
