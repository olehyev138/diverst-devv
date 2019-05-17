class AddSubErgToCustomText < ActiveRecord::Migration[5.1]
  def change
  	add_column :custom_texts, :sub_erg, :text
  end
end
