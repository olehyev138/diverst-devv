class AddDeclineReasonToBudgets < ActiveRecord::Migration
  def change
    add_column :budgets, :decline_reason, :string
  end
end
