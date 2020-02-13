class AddUserOnboardingEmail < ActiveRecord::Migration
  def up
    Email.where(:name => "User Onboarding Mailer").destroy_all

    attributes = {
      :name => "User Onboarding Mailer",
      :mailer_name => "diverst_mailer",
      :mailer_method => "invitation_instructions",
      :content => "<p>Welcome to Diverst!</p>\r\n\r\n<p>At Diverst, we embrace our differences. Diversity in all of its forms is key to our firm&rsquo;s open culture and long-term success. We believe that a diverse workforce where varying perspectives and backgrounds collaborate, will ultimately produce better results for our employees, business and investors.</p>\r\n\r\n<p><strong>That is why we are so excited to introduce you to Diverst, a community-based program focused on bringing together our unique experiences, backgrounds and perspectives to impact a greater ONE. While ONE firm, we are made of many distinctive parts that together influence innovation, performance, and thought leadership. Building and maintaining a diverse culture of belonging is a shared responsibility &ndash; from employees to senior leaders. As ONE, we will leverage the firm&rsquo;s full potential by promoting and supporting activities that celebrate diversity and develop an awareness of inclusion throughout our organization.</strong></p>\r\n\r\n<p>Via your Diverst ONE community portal, you can learn about the latest news and events related to inclusion and diversity, as well as participate in our Employee Resource Group program (ERGs).</p>\r\n\r\n<p>%{click_here} to get started by building your profile and checking out all the different ways you can get involved. You can also access your Portal via the link on the top navigation bar of the Intranet Homepage.</p>\r\n\r\n<p>If you have any questions or need assistance, please contact info@diverst.com.</p>\r\n",
      :subject => "Invitation Instructions",
      :description => "Email that goes out to users after they've been added.",
      :template => ""
    }

    Enterprise.find_each do |enterprise|
      email = Email.new
      email.enterprise = enterprise
      email.attributes = attributes
      email.save(validate: false)

      enterprise.email_variables.where(key: ["user.name", "enterprise.name", "click_here"]).each do |email_variable|
        email_variable.emails << email
      end
    end
  end

  def down
    Email.where(:name => "User Onboarding Mailer").destroy_all
  end
end
