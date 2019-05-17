class AddBannerToGroups < ActiveRecord::Migration[5.1]
  def change
    add_attachment :groups, :banner
  end
end
