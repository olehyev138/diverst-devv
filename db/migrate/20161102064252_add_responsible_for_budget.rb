class AddResponsibleForBudget < ActiveRecord::Migration
  def change
    change_table :groups do |t|
      t.string :budget_manager_email
    end

    change_table :enterprises do |t|
      t.string :budget_manager_email
    end
  end
end
