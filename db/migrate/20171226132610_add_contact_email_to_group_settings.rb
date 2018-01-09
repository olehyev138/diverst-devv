class AddContactEmailToGroupSettings < ActiveRecord::Migration
  def change
  	add_column :groups, :contact_email, :string, unique: true
  end
end
