class AddIdeaCategoryIdToAnswer < ActiveRecord::Migration
  def change
    add_column :answers, :idea_category_id, :integer
  end
end
