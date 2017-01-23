class AddStatusToPolls < ActiveRecord::Migration
  def change
    add_column :polls, :status, :integer, index: true, default: 0, null: false
  end
end
