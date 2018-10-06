class AddParentErgToCustomText < ActiveRecord::Migration
  def change
    # for parent groups
    add_column :custom_texts, :parent, :text
  end
end
