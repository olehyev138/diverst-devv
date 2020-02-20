class AddConsentAttributeToPolicyGroup < ActiveRecord::Migration
  def change
    add_column :policy_groups, :onboarding_consent_manage, :boolean, default: false
    add_column :policy_group_templates, :onboarding_consent_manage, :boolean, default: false
  end
end
