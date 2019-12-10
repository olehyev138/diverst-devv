class FixGroupSponsorMediaColumnNames < ActiveRecord::Migration[5.2]
  def change
    rename_column :groups, :sponsor_image_file_name, :sponsor_media_file_name
    rename_column :groups, :sponsor_image_content_type, :sponsor_media_content_type
    rename_column :groups, :sponsor_image_file_size, :sponsor_media_file_size
    rename_column :groups, :sponsor_image_updated_at, :sponsor_media_updated_at
  end
end