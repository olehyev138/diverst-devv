class DiverstMailer < ApplicationMailer
  include MailHelper

  def invitation_instructions(user, token)
    @user = user
    @token = InviteTokenService.request_token(user)
    @enterprise = @user.enterprise
    return if @enterprise.disable_emails?
    return unless @enterprise.has_enabled_onboarding_email?

    @email = @user.email
    set_defaults(@enterprise, method_name)

    mail(from: @from_address, to: @email, subject: @subject)
  end

  def new_email_update(user_id, new_email_address)
    @user = User.find(user_id)
    @enterprise = @user.enterprise
    return if @enterprise.disable_emails?

    @email = new_email_address
    set_defaults(@enterprise, method_name)

    mail(from: @from_address, to: @email, subject: @subject)
  end

  def old_email_update(user_id, old_email_address)
    @user = User.find(user_id)
    @enterprise = @user.enterprise
    return if @enterprise.disable_emails?

    @email = old_email_address
    set_defaults(@enterprise, method_name)

    mail(from: @from_address, to: @email, subject: @subject)
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
