class AddApproverIdAndRequesterIdToBudgets < ActiveRecord::Migration
  def change
    add_column :budgets, :approver_id, :integer, index: true
    add_foreign_key :budgets, :users, column: :approver_id
    add_column :budgets, :requester_id, :integer, index: true
    add_foreign_key :budgets, :users, column: :requester_id
  end
end
