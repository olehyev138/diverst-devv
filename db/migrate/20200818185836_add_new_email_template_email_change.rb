class AddNewEmailTemplateEmailChange < ActiveRecord::Migration[5.2]
  def up
    previous = {
        name: 'Previous Email Modification Mailer',
        mailer_name: 'diverst_mailer',
        mailer_method: 'old_email_update',
        content: "<p>Dear %{user.name}, </p>\r\n\r\n<p>Your email address has successfully been updated. You may no longer use
        this email address to sign in to your organization's Diverst platform.</p>\r\n<p>
        If you did not request to change your email address or if you are unsure why your email address has been changed,
        please contact an administrator.</p>\r\n\r\n<p>If you have any questions or
        need further assistance, please contact info@diverst.com.</p>\r\n",
        subject: 'Change of email address',
        description: "Email that goes out to users after they've changed their associated email address",
        template: ''
    }

    new = {
        name: 'New Email Modification Mailer',
        mailer_name: 'diverst_mailer',
        mailer_method: 'new_email_update',
        content: "<p>Dear %{user.name}, </p>\r\n\r\n<p>Your email address has successfully been updated. This email
        address is now the email address that will be used to sign in to your organization's Diverst Platform</p>\r\n<p>
        If you did not request to change your email address or if you are unsure why your email address has been changed,
        please contact an administrator.</p>\r\n\r\n<p>If you have any questions or
        need further assistance, please contact info@diverst.com.</p>\r\n",
        subject: 'Change of email address',
        description: "Email that goes out to users after they've changed their associated email address",
        template: ''
    }

    Enterprise.column_reload!
    Enterprise.find_each do |enterprise|
      old_email = enterprise.emails.create(previous)
      new_email = enterprise.emails.create(new)

      enterprise.email_variables.where(key: ['user.name', 'enterprise.name', 'click_here']).each do |email_variable|
        email_variable.emails << old_email
        email_variable.emails << new_email
      end
    end
  end
end
