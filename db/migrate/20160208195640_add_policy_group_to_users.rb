class AddPolicyGroupToUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.belongs_to :policy_group
    end
  end
end
