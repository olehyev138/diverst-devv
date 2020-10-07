class AddLoginTextAttributeToEnterprise < ActiveRecord::Migration
  def change
    add_column :enterprises, :login_text, :text
  end
end
