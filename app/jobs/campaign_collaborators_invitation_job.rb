class CampaignCollaboratorsInvitationJob < ActiveJob::Base
  queue_as :mailers

  def perform(campaign_id, user_id)
    return if campaign_id.nil? || user_id.nil?

    CampaignInviteForCollaborationMailer.invitation_to_collaborate(campaign_id, user_id).deliver_later
  end
end
