class AddNewFieldsToCustomTexts < ActiveRecord::Migration
  def change
    add_column :custom_texts, :segment, :text
    add_column :custom_texts, :dci_full_title, :text
    add_column :custom_texts, :dci_abbreviation, :text
    add_column :custom_texts, :member_preference, :text
  end
end
