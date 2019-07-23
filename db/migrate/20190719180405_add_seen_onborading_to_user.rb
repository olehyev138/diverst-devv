class AddSeenOnboradingToUser < ActiveRecord::Migration
  def change
    add_column :users, :seen_onborading, :boolean, default: false
  end
end
