class ConsentToggle < ActiveRecord::Migration[5.2]
  def change
    add_column :enterprises, :onboarding_consent_enabled, :boolean, default: false
  end
end
