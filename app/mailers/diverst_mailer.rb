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

  def new_email_update(user_id, new_email_address)
    @user = User.find(user_id)
    @enterprise = @user.enterprise
    return if @enterprise.disable_emails?

    set_defaults(@enterprise, method_name)
    mail(from: @from_address, to: new_email_address, subject: @subject)
  end

  def old_email_update(user_id, old_email_address)
    @user = User.find(user_id)
    @enterprise = @user.enterprise
    return if @enterprise.disable_emails?

    set_defaults(@enterprise, method_name)
    mail(from: @from_address, to: old_email_address, subject: @subject)
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
