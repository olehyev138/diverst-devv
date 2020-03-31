class AddBooleanForNonssoActivationLink < ActiveRecord::Migration
  def change
    add_column :enterprises, :nonsso_activation_switch, :boolean, default: false 
  end
end
