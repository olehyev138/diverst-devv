class RemoveSuggestedHireIdFromSuggestedHires < ActiveRecord::Migration
  def change
    remove_column :suggested_hires, :suggested_hire_id, :integer
    add_column :suggested_hires, :email, :string
    add_column :suggested_hires, :name, :string
  end
end
