class AddBadgeToCustomTexts < ActiveRecord::Migration[5.1]
  def change
    add_column :custom_texts, :badge, :text
  end
end
