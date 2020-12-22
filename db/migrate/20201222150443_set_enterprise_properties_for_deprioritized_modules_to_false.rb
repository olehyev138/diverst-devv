class SetEnterprisePropertiesForDeprioritizedModulesToFalse < ActiveRecord::Migration[5.2]
  def change
    Enterprise.update_all("mentorship_module_enabled=false")
    Enterprise.update_all("collaborate_module_enabled=false")
  end
end
