class ChangeHomeMessageSizeInEnterprises < ActiveRecord::Migration[5.1]
  def up
      change_column :enterprises, :home_message, :text
  end
  def down
      # This might cause trouble if you have strings longer
      # than 255 characters.
      change_column :enterprises, :home_message, :string
  end
end
