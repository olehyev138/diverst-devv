class ResetPasswordMailer < ApplicationMailer
  include MailHelper

  def reset_password_instructions(user, token)
    @user = user
    @token = PasswordResetTokenService.request_token(user)
    @enterprise = @user.enterprise
    return if @enterprise.disable_emails?

    @email = @user.email
    set_defaults(@enterprise, method_name)

    mail(from: @from_address, to: @email, subject: @subject)
  end

  def variables
    {
      user: @user,
      enterprise: @enterprise,
      custom_text: @enterprise.custom_text,
      click_here: "<a href=\"#{ReactRoutes.session.passwordReset(@token)}\" target=\"_blank\">Click Here</a>",
    }
  end

  def url
    ReactRoutes.user.home
  end
end
