class AddDeclineReasonToBudgets < ActiveRecord::Migration[5.1]
  def change
    add_column :budgets, :decline_reason, :string
  end
end
