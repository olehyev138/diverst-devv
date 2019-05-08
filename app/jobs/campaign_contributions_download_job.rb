class CampaignContributionsDownloadJob < ActiveJob::Base
  queue_as :default

  def perform(user_id, campaign_id, erg_text)
    user = User.find_by_id(user_id)
    return if user.nil?

    campaign = Campaign.find_by_id(campaign_id)
    return if campaign.nil?

    csv = campaign.contributions_per_erg_csv(erg_text)
    file = CsvFile.new(user_id: user.id, download_file_name: 'contributions_per_erg')

    file.download_file = StringIO.new(csv)
    file.download_file.instance_write(:content_type, 'text/csv')
    file.download_file.instance_write(:file_name, 'contributions_per_erg.csv')

    file.save!
  end
end
