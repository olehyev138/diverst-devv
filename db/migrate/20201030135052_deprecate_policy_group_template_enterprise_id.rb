class DeprecatePolicyGroupTemplateEnterpriseId < ActiveRecord::Migration[5.2]
  def change
    rename_column :policy_group_templates, :enterprise_id, :deprecated_enterprise_id
  end
end
