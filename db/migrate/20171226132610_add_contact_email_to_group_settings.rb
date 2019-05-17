class AddContactEmailToGroupSettings < ActiveRecord::Migration[5.1]
  def change
  	add_column :groups, :contact_email, :string, unique: true
  end
end
