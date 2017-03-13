class AddHasEnabledOnboardingEmailToEnterprises < ActiveRecord::Migration
  def change
    add_column :enterprises, :has_enabled_onboarding_email, :boolean, default: true
  end
end
