class CampaignResponseNotifierJob < ActiveJob::Base
  queue_as :mailers

  def perform(answer_id, campaign_id)
    answer = Answer.find_by(id: answer_id)
    campaign = Campaign.find_by(id: campaign_id)
    return if answer.nil? || campaign.nil?

    CampaignResponseMailer.notification(answer_id, campaign_id).deliver_later
  end
end
