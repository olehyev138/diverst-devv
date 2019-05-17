class RemoveContactEmailFieldFromGroups < ActiveRecord::Migration[5.1]
  def change
  	remove_column :groups, :contact_email
  end
end
