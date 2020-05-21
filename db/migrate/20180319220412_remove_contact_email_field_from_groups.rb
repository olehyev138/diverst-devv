class RemoveContactEmailFieldFromGroups < ActiveRecord::Migration
  def change
    remove_column :groups, :contact_email
  end
end
