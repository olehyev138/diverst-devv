class AddOutlookFlagToEnterprise < ActiveRecord::Migration[5.2]
  def change
    add_column :enterprises, :enable_outlook, :boolean, default: false
  end
end
