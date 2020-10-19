class AddColumnsToEnterprises < ActiveRecord::Migration
  def change
    add_column :enterprises, :invite_member_enabled, :boolean, default: false
    add_column :enterprises, :suggest_hire_enabled, :boolean, default: false
  end
end
