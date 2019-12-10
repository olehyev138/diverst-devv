class CampaignTopPerformersDownloadJob < ActiveJob::Base
  queue_as :default

  def perform(user_id, campaign_id)
    user = User.find_by_id(user_id)
    return if user.nil?

    campaign = Campaign.find_by_id(campaign_id)
    return if campaign.nil?

    csv = campaign.top_performers_csv
    file = CsvFile.new(user_id: user.id, download_file_name: 'top_performers')

    file.download_file.attach(io: StringIO.new(csv), filename: "#{file.download_file_name}.csv", content_type: 'text/csv')

    file.save!
  end
end
