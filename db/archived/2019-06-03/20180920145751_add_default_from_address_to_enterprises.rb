class AddDefaultFromAddressToEnterprises < ActiveRecord::Migration[5.1]
  def change
    add_column  :enterprises, :default_from_email_address,      :string
    add_column  :enterprises, :default_from_email_display_name, :string
  end
end
