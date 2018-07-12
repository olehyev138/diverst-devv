class AddIsPinnedToShareLinks < ActiveRecord::Migration
  def change
    add_column :share_links, :is_pinned, :boolean, default: false
  end
end
