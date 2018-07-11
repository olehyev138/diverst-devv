class AddCommentsToBudgets < ActiveRecord::Migration
  def change
    add_column :budgets, :comments, :text
  end
end
