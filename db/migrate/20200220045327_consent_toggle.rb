class ConsentToggle < ActiveRecord::Migration
  def change
    add_column :enterprises, :onboarding_consent_enabled, :boolean, default: false
  end
end
