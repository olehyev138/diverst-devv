class DropConsentManageAttributeFromPolicyGroupsAndPolicyGroupTemplates < ActiveRecord::Migration[5.2]
  def change
    if column_exists? :policy_groups, :onboarding_consent_manage
      remove_column :policy_groups, :onboarding_consent_manage, :boolean
    end

    if column_exists? :policy_group_templates, :onboarding_consent_manage
      remove_column :policy_group_templates, :onboarding_consent_manage, :boolean
    end
  end
end
