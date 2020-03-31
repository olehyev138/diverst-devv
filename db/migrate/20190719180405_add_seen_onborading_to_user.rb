class AddSeenOnboradingToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :seen_onborading, :boolean, default: false
  end
end
