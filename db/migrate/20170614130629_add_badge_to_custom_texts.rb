class AddBadgeToCustomTexts < ActiveRecord::Migration
  def change
    add_column :custom_texts, :badge, :text
  end
end
