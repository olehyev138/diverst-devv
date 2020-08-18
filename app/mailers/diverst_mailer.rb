class DiverstMailer < ApplicationMailer
  include MailHelper

  def invitation_instructions(user, token)
    @user = user
    @token = InviteTokenService.request_token(user)
    @enterprise = @user.enterprise
    return if @enterprise.disable_emails?

    set_defaults(@enterprise, method_name)

    mail(from: @from_address, to: @user.email, subject: @subject)
  end

  def new_email_update(new_user)
    @user = new_user
    @enterprise = @user.enterprise
    return if @enterprise.disable_emails?
    set_defaults(@enterprise, method_name)
    mail(from: @from_address, to: user.email, subject: @subject)
  end

  def old_email_update(old_user)
    @user = old_user
    @enterprise = @user.enterprise
    return if @enterprise.disable_emails?

    mail(from: @from_address, to: user.email, subject: @subject)
  end

  def variables
    {
      user: @user,
      enterprise: @enterprise,
      custom_text: @enterprise.custom_text,
      click_here: "<a href=\"#{ReactRoutes.anonymous.signUp(@token)}\" target=\"_blank\">Click Here</a>",
    }
  end

  def url
    ReactRoutes.user.home
  end
end
