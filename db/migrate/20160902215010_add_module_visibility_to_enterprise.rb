class AddModuleVisibilityToEnterprise < ActiveRecord::Migration[5.1]
  def change
    change_table :enterprises do |t|
      t.boolean :collaborate_module_enabled,  default: 1, null: false
      t.boolean :scope_module_enabled,        default: 1, null: false
      t.boolean :bias_module_enabled,         default: 1, null: false
      t.boolean :plan_module_enabled,         default: 1, null: false
    end
  end
end
