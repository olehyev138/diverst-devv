class AddEmailFieldToSuggestHire < ActiveRecord::Migration
  def change
    rename_column :suggested_hires, :email, :candidate_email
    rename_column :suggested_hires, :name, :candidate_name
    add_column :suggested_hires, :hr_email, :string
  end
end
