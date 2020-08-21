class CampaignInvitationMailerMigration < ActiveRecord::Migration
  def change
    Enterprise.all.each do |enterprise|
      campaign_invitation_email = enterprise.emails.find_or_create_by(
        name: "Campaign Invite For Collaboration Mailer"
      )
      campaign_invitation_email.update(
        enterprise: enterprise,
        mailer_name: "campaign_invite_for_collaboration_mailer",
        mailer_method: "invitation_to_collaborate",
        content: "<p>Hello %{user.name},</p>\r\n\r\n<p>You have been invited to collaborate on <strong> %{campaign.title} </strong> campaign.</p><p>%{click_here} to collaborate with others.</p></p>",
        subject: "Invitation to collaborate on %{campaign.title} campaign",
        description: "Email that goes out to users to invite them to collaborate with others on campaign.",
        template: ""
      )

      enterprise.email_variables.where(key: ["user.name", "campaign.title", "enterprise.name", "click_here", "custom_text.erg_text"]).each do |email_variable|
        email_variable.emails << campaign_invitation_email
      end
    end
  end
end
