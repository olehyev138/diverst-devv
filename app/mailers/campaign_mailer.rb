class CampaignMailer < ApplicationMailer
  def invitation(inv)
    @invitation = inv
    @enterprise_id = @invitation.user.enterprise.id
    mail(to: inv.user.email, subject: 'Help your coworkers solve a problem')
    inv.update(email_sent: true)
  end
end
