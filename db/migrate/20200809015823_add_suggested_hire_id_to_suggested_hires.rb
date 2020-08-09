class AddSuggestedHireIdToSuggestedHires < ActiveRecord::Migration
  def change
    add_column :suggested_hires, :suggested_hire_id, :integer
  end
end
