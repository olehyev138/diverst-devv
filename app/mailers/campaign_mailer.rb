class CampaignMailer < ApplicationMailer
  def invitation(inv)
    @invitation = inv
    @enterprise_id = @invitation.user.enterprise.id

    group_names = 'us'
    if inv.campaign.groups.any?
      group_names = inv.campaign.groups.map{ |g| g.name}.join(', ')
    end

    subject =  "You are invited to join #{group_names} in an online conversation in Diverst."
    
    url = user_user_campaign_questions_url(@invitation.campaign)
    @mailer_text = @invitation.user.enterprise.campaign_mailer_notification_text  % { user_name: @invitation.user.name, campaign_name: inv.campaign.title, join_now: "<a saml_for_enterprise=\"#{@enterprise_id}\" href=\"#{url}\" target=\"_blank\">Join Now</a>" }

    mail(to: inv.user.email, subject: subject)

    inv.email_sent = true
    inv.save!
  end
end
