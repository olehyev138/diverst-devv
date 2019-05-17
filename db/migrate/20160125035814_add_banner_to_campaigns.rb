class AddBannerToCampaigns < ActiveRecord::Migration[5.1]
  def change
    change_table :campaigns do |t|
      t.attachment :banner
    end
  end
end
