class RemoveBiasModuleEnabledColumnFromEnterprises < ActiveRecord::Migration
  def change
    remove_column :enterprises, :bias_module_enabled, :boolean
  end
end
