class AddOutlookFlagToEnterprise < ActiveRecord::Migration
  def change
    add_column :enterprises, :enable_outlook, :boolean, default: false
  end
end
