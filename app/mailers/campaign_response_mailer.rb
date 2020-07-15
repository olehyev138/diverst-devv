class CampaignResponseMailer < ApplicationMailer
  def notification(answer_id, campaign_id)
    @answer = Answer.find_by(id: answer_id)
    @campaign = Campaign.find_by(id: campaign_id)
    @enterprise = @campaign.enterprise
    @user = @answer.author
    @sponsor_name = @campaign.owner.name
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
      sponsor_name: @sponsor_name,
      enterprise: @enterprise
    }
  end
end
