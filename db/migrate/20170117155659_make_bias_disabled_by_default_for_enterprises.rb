class MakeBiasDisabledByDefaultForEnterprises < ActiveRecord::Migration
  def up
    change_column :enterprises, :bias_module_enabled, :boolean, default: false
  end

  def down
    change_column :enterprises, :bias_module_enabled, :boolean, default: true
  end
end
