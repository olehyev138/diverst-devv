class UpdateWelcomeMailerContent < ActiveRecord::Migration[5.2]
  def up
    content = "<p>Hello %{user.name},</p>\r\n\r\n<p>Welcome as a new member of %{group.name}! %{click_here} to check our page often for latest news and messages and look forward to seeing you at our events!.</p>\r\n"
    Enterprise.all.each do |enterprise|
      email = Email.where(enterprise: enterprise, mailer_name: 'welcome_mailer').first
      if email.present?
        email.content = content
        email.save(validate: false)
      end
    end
  end

  def down
    content = "<p>Hello %{user.name},</p>\r\n\r\n<p>Welcome as a new member of %{group.name}! Be sure to check our page often for latest news and messages and look forward to seeing you at our events!.</p>\r\n"
    Enterprise.all.each do |enterprise|
      email = Email.where(enterprise: enterprise, mailer_name: 'welcome_mailer').first
      if email.present?
        email.content = content
        email.save(validate: false)
      end
    end
  end
end
