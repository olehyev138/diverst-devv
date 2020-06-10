class DropConsentManageAttributeFromPolicyGroupsAndPolicyGroupTemplates < ActiveRecord::Migration[5.2]
  def change
    remove_column :policy_groups, :onboarding_consent_manage, :boolean
    remove_column :policy_group_templates, :onboarding_consent_manage, :boolean
  end
end
