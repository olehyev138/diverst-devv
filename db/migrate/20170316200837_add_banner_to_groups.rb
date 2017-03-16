class AddBannerToGroups < ActiveRecord::Migration
  def change
    add_attachment :groups, :banner
  end
end
