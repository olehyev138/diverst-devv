class SetSeenOnboardingToTrue < ActiveRecord::Migration[5.2]
  def change
    User.where('sign_in_count > ?', 0).update_all(seen_onboarding: true)
  end
end


