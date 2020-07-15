class CampaignResponseMailerMigration < ActiveRecord::Migration
  def change
    Enterprise.all.each do |enterprise|
      campaign_response_email = enterprise.emails.find_or_create_by(
        name: 'Campaign Response Notification Mailer'
      )
      campaign_response_email.update(
        enterprise: enterprise,
        mailer_name: "campaign_response_mailer",
        mailer_method: "notification",
        content: "<p>Thank you for submitting an idea to %{campaign.title} campaign. Your idea response is being evaluated now.<p>Sincerely, %{sponsor_name} Sponsor</p></p>",
        subject: "Thank you for participating in our %{campaign.title} campaign",
        description: "Email that goes out to users after they have submitted an idea.",
        template: ""
      )

      enterprise.email_variables.create(
        {
          key: "sponsor_name",
          description: "Displays a sponsor's name",
          example: 'Elon Musk',
          emails: enterprise.emails
        }
        
      )

      enterprise.email_variables.where(key: ["user.name", "campaign.title", "sponsor_name", "enterprise.name"]).each do |email_variable|
        email_variable.emails << campaign_response_email
      end
    end
  end
end
