class AddResetPasswordEmail < ActiveRecord::Migration[5.2]
  def change
    Enterprise.column_reload!
    Enterprise.find_each do |ent|
      unless ent.emails.where(mailer_name: 'reset_password_mailer', mailer_method: 'reset_password_instructions').exists?
        ent.emails.create({
                              name: 'Password Reset Mailer',
                              subject: 'Password Reset',
                              content: "<h2> Hi %{user.name} </h2>\r\n"+
                                  "<p> You recently requested to have your Diverst password reset. To complete the process please %{click_here} to enter your new password </p>\r\n" +
                                  "<p> If you didn't request a password reset, please ignore this email </p>\r\n" +
                                  "<p> The reset password link will expire in 30 minutes </p>\r\n",
                              mailer_name: 'reset_password_mailer',
                              mailer_method: 'reset_password_instructions',
                              template: '',
                              description: 'Email that goes out when a user requests a password reset',
                              custom: false,
                              variable_ids: EnterpriseEmailVariable.where(enterprise: ent, key: ['user.name', 'enterprise.id', 'enterprise.name', 'click_here']).ids
                          })
      end
    end
  end
end
