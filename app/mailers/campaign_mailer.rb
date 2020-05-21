class CampaignMailer < ApplicationMailer
  def invitation(inv)
    @invitation = inv
    @user = @invitation.user
    @campaign = @invitation.campaign
    @enterprise = @user.enterprise
    return if @enterprise.disable_emails?

    @email = @user.email_for_notification

    @group_names = 'us'
    if inv.campaign.groups.any?
      @group_names = inv.campaign.groups.map { |g| g.name }.join(', ')
    end

    set_defaults(@user.enterprise, method_name)

    mail(from: @from_address, to: @email, subject: @subject)

    inv.email_sent = true
    inv.save!
  end

  def variables
    {
      user: @user,
      enterprise: @enterprise,
      campaign: @campaign,
      group_names: @group_names
    }
  end

  def url
    campaign_url(@campaign)
  end
end
