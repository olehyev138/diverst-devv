class CampaignMailer < ApplicationMailer
  def invitation(inv)
    @invitation = inv
    @user = @invitation.user
    @campaign = @invitation.campaign
    @enterprise = @user.enterprise
    
    @group_names = 'us'
    if inv.campaign.groups.any?
      @group_names = inv.campaign.groups.map{ |g| g.name}.join(', ')
    end

    set_defaults(@user.enterprise, method_name)

    mail(to: @user.email, subject: @subject)

    inv.email_sent = true
    inv.save!
  end
  
  def variables
    {
      :user => @user,
      :enterprise => @enterprise,
      :campaign => @campaign,
      :group_names => @group_names
    }
  end
end
