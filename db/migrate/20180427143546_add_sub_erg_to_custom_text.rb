class AddSubErgToCustomText < ActiveRecord::Migration
  def change
    add_column :custom_texts, :sub_erg, :text
  end
end
