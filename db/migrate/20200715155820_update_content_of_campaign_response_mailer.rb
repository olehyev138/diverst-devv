class UpdateContentOfCampaignResponseMailer < ActiveRecord::Migration
  def change
    Enterprise.all.each do |enteprise|
      campaign_response_mail = enteprise.emails.find_by(name: 'Campaign Response Notification Mailer')
      campaign_response_mail.update(content: "<p>Hello %{user.name},</p>\r\n\r\n<p>Thank you for submitting an idea to <strong> %{campaign.title} </strong> campaign. Your idea response is being evaluated now. </p><p>Sincerely, %{sponsor_name} (Campaign Sponsor)</p></p>")
    end
  end
end
