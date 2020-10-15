class AddIdeaCategoryIdToAnswer < ActiveRecord::Migration[5.2]
  def change
    #
    ## Legacy migration
    #
    unless column_exists? :answers, :idea_category_id
      add_column :answers, :idea_category_id, :integer
    end
  end
end
