class AddFinishedExpensesToInitiatives < ActiveRecord::Migration
  def change
    change_table :initiatives do |t|
      t.boolean :finished_expenses, default: false
    end
  end
end
