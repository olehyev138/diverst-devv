class AddRegionToCustomTexts < ActiveRecord::Migration[5.2]
  def change
    add_column :custom_texts, :region, :string, default: 'Region', null: false
  end
end
