class RemoveBiasModuleEnabledColumnFromEnterprises < ActiveRecord::Migration[5.1]
  def change
  	remove_column :enterprises, :bias_module_enabled, :boolean
  end
end
