class AddLoginTextAttributeToEnterprise < ActiveRecord::Migration[5.2]
  def change
    #
    ## Legacy migration
    #
    unless column_exists? :enterprises, :login_text
      add_column :enterprises, :login_text, :text
    end
  end
end
