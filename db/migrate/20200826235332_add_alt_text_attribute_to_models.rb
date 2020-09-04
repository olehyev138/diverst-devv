class AddAltTextAttributeToModels < ActiveRecord::Migration
  def change
    add_column :initiatives, :pic_alt_text_desc, :string 
    
    add_column :groups, :logo_alt_text_desc, :string
    add_column :groups, :banner_alt_text_desc, :string
    
    add_column :sponsors, :sponsor_alt_text_desc, :string

    add_column :enterprises, :cdo_alt_text_desc, :string
    add_column :enterprises, :banner_alt_text_desc, :string

    add_column :campaigns, :image_alt_text_desc, :string
    add_column :campaigns, :banner_alt_text_desc, :string

    add_column :rewards, :pic_alt_text_desc, :string
    add_column :badges, :image_alt_text_desc, :string

    add_column :expense_categories, :icon_alt_text_desc, :string
    add_column :news_link_photos, :photo_alt_text_desc, :string

    add_column :news_links, :pic_alt_text_desc, :string
  end
end
