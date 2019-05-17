class AddCommentsToBudgets < ActiveRecord::Migration[5.1]
  def change
    add_column :budgets, :comments, :text
  end
end
