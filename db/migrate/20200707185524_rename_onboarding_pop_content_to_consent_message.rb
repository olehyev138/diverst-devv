class RenameOnboardingPopContentToConsentMessage < ActiveRecord::Migration[5.2]
  def change
    rename_column :enterprises, :onboarding_pop_up_content, :onboarding_consent_message
  end
end
