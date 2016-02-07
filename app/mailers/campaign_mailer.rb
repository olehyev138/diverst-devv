class CampaignMailer < ApplicationMailer
  def invitation(inv)
    @invitation = inv
    mail(to: inv.user.email, subject: 'Help your coworkers solve a problem')
    inv.update(email_sent: true)
  end
end
