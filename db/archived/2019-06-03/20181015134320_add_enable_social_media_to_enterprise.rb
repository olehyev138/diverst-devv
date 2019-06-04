class AddEnableSocialMediaToEnterprise < ActiveRecord::Migration[5.1]
  def change
    add_column :enterprises, :enable_social_media, :boolean, default: false
  end
end
