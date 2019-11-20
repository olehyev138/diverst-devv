class UpdateWelcomeMailerContent < ActiveRecord::Migration
  def up
    content = "<p>Hello %{user.name},</p>\r\n\r\n<p>Welcome as a new member of %{group.name}! %{click_here} to check our page often for latest news and messages and look forward to seeing you at our events!.</p>\r\n"
    Enterprise.all.each do |enterprise|
      enterprise.emails.find_by_mailer_name('welcome_mailer')&.update(content: content)
    end
  end

  def down
    content = "<p>Hello %{user.name},</p>\r\n\r\n<p>Welcome as a new member of %{group.name}! Be sure to check our page often for latest news and messages and look forward to seeing you at our events!.</p>\r\n"
    Enterprise.all.each do |enterprise|
      enterprise.emails.find_by_mailer_name('welcome_mailer')&.update(content: content)
    end
  end
end
