class AddBannerToCampaigns < ActiveRecord::Migration
  def change
    change_table :campaigns do |t|
      t.attachment :banner
    end
  end
end
