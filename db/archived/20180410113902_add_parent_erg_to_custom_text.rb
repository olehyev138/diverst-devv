class AddParentErgToCustomText < ActiveRecord::Migration[5.1]
  def change
    # for parent groups
    add_column :custom_texts, :parent, :text
  end
end
