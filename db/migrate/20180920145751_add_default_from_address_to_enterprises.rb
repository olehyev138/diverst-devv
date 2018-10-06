class AddDefaultFromAddressToEnterprises < ActiveRecord::Migration
  def change
    add_column  :enterprises, :default_from_email_address,      :string
    add_column  :enterprises, :default_from_email_display_name, :string
  end
end
