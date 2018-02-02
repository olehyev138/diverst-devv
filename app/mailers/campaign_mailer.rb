class CampaignMailer < ApplicationMailer
  def invitation(inv)
    @invitation = inv
    @enterprise_id = @invitation.user.enterprise.id

    group_names = 'us'
    if inv.campaign.groups.any?
      group_names = inv.campaign.groups.map{ |g| g.name}.join(', ')
    end

    subject =  "You are invited to join #{group_names} in an online conversation in Diverst. "

    mail(to: inv.user.email, subject: subject)

    inv.email_sent = true
    inv.save!
  end
end
