class CampaignInviteForCollaborationMailer < ApplicationMailer
  def invitation_to_collaborate(campaign_id, user_id)
    @campaign = Campaign.find_by(id: campaign_id)
    @user = User.find_by(id: user_id)
    @enterprise = @campaign.enterprise
    return if @enterprise.disable_emails?

    @custom_text = @enterprise.custom_text rescue CustomText.new
    @email = @user.email_for_notification

    set_defaults(@enterprise, method_name)

    mail(from: @from_address, to: @email, subject: @subject)
  end

  def variables
    {
        user: @user,
        campaign: @campaign,
        enterprise: @enterprise,
        custom_text: @custom_text,
        click_here: "<a saml_for_enterprise=\"#{@enterprise.id}\" href=\"#{url}\" target=\"_blank\">Click here</a>"
    }
  end

  def url
    campaign_questions_url(@campaign)
  end
end
