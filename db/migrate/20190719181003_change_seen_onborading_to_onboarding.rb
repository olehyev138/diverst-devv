class ChangeSeenOnboradingToOnboarding < ActiveRecord::Migration
  def change
    rename_column :users, :seen_onborading, :seen_onboarding
  end
end
