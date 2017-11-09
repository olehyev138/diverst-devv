class CampaignMailer < ApplicationMailer
    
    def invitation(inv)
        @invitation = inv
        @enterprise_id = @invitation.user.enterprise.id
        @group = Group.find_by(owner_id: @invitation.user.id)
        mail(to: inv.user.email, subject: ' You are invited to join a #{@group.name} online conversation in Diverst!')
        
        inv.email_sent = true
        inv.save!
    end
end
