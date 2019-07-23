class SetSeenOnboradingToTrue < ActiveRecord::Migration
  def change
    User.where('sign_in_count > ?', 0).each do |usr|
      usr.seen_onboarding = true
      usr.save
    end
  end
end
