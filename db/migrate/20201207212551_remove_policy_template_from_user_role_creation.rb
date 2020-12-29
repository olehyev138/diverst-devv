class RemovePolicyTemplateFromUserRoleCreation < ActiveRecord::Migration[5.2]
  def change
    PolicyGroupTemplate.update_all('name = replace(name, " Policy Template", "")')
    PolicyGroupTemplate.update_all('name = replace(name, "Policy Template", "")')
  end
end
