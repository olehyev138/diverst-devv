class AddLeadManagerToGroups < ActiveRecord::Migration[5.1]
  def change
    change_table :groups do |t|
      t.belongs_to :lead_manager
    end
  end
end
