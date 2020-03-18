class AddQuestionsCountToCampaigns < ActiveRecord::Migration[5.2]
  def change
    add_column :campaigns, :questions_count, :integer

    Campaign.find_each do |campaign|
      Campaign.reset_counters(campaign.id, :questions)
    end
  end
end
