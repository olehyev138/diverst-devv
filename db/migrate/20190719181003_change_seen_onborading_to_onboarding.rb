class ChangeSeenOnboradingToOnboarding < ActiveRecord::Migration[5.2]
  def change
    rename_column :users, :seen_onborading, :seen_onboarding
  end
end
