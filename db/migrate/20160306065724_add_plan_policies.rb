class AddPlanPolicies < ActiveRecord::Migration[5.1]
  def change
    change_table :policy_groups do |t|
      t.boolean :initiatives_index, default: false
      t.boolean :initiatives_create, default: false
      t.boolean :initiatives_manage, default: false
    end
  end
end
