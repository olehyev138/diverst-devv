class AddFieldsToEnterprises < ActiveRecord::Migration
  def change
    add_column :enterprises, :redirect_all_emails,    :boolean, :default => false
    add_column :enterprises, :redirect_email_contact, :string
    add_column :enterprises, :disable_emails,         :boolean, :default => false
  end
end
