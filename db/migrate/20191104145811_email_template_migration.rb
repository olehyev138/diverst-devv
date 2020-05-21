class EmailTemplateMigration < ActiveRecord::Migration
  def change
    Enterprise.all.each do |enterprise|
      campaign_email = enterprise.emails.find_by(name: 'Campaign Mailer')
      campaign_email&.update(:content => "<p>Hello %{user.name},</p>\r\n\r\n<p>You are invited to join other members in the following online collaborative conversation in Diverst: %{campaign.title}</p>\r\n\r\n<p>%{click_here} to provide feedback and offer your thoughts and suggestions.</p>\r\n")

      welcome_email = Email.find_or_create_by(name: 'Welcome Mailer')
      welcome_email.update(:enterprise => enterprise,
        :mailer_name => 'welcome_mailer',
        :mailer_method => 'notification',
        :content => "<p>Hello %{user.name},</p>\r\n\r\n<p>Welcome as a new member of %{group.name}! Select the link(s) below to access Diverst and discover the %{group.name} Home page.</p>\r\n",
        :subject => "Hi %{user.name} and welcome to %{group.name}.",
        :description => "Email that goes out to group leaders when there are pending group members",
        :template => "")
    end
  end
end
