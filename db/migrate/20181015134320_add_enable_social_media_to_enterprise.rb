class AddEnableSocialMediaToEnterprise < ActiveRecord::Migration
  def change
    add_column :enterprises, :enable_social_media, :boolean, default: false
  end
end
