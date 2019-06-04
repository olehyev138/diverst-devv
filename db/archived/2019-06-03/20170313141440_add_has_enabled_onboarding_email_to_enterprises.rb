class AddHasEnabledOnboardingEmailToEnterprises < ActiveRecord::Migration[5.1]
  def change
    add_column :enterprises, :has_enabled_onboarding_email, :boolean, default: true
  end
end
