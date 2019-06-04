class AddPolicyGroupToUsers < ActiveRecord::Migration[5.1]
  def change
    change_table :users do |t|
      t.belongs_to :policy_group
    end
  end
end
