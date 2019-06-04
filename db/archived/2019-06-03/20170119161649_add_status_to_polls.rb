class AddStatusToPolls < ActiveRecord::Migration[5.1]
  def change
    add_column :polls, :status, :integer, index: true, default: 0, null: false
  end
end
