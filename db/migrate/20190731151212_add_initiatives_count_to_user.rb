class AddInitiativesCountToUser < ActiveRecord::Migration
  def change
    add_column :users, :initiatives_count, :integer
  end
end
