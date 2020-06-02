class ResetPasswordMailer < ApplicationMailer
  include MailHelper

  def reset_password_instructions(user, token)
    @user = user
    @token = PasswordResetTokenService.first_jwt(user)
    @enterprise = @user.enterprise
    return if @enterprise.disable_emails?

    set_defaults(@enterprise, method_name)

    mail(from: @from_address, to: @user.email, subject: @subject)
  end

  # def headers_for(action, opts)
  #   headers = {
  #     subject: @subject || subject_for(action),
  #     to: @email || resource.email_for_notification,
  #     from: @from_address, # TODO: devise
  #     reply_to: @from_address, # TODO: devise
  #     template_path: template_paths,
  #     template_name: action
  #   }.merge(opts)
  #
  #   @email = headers[:to]
  #   headers
  # end

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
