class AddLinkToVideo < ActiveRecord::Migration
  def change
    add_column :groups, :company_video_url, :string
    add_column :enterprises, :company_video_url, :string
  end
end
