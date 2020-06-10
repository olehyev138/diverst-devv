class PollMailer < ApplicationMailer
  def invitation(poll, user)
    @user = user
    @poll = poll
    @enterprise = @user.enterprise
    return if @enterprise.disable_emails?

    @custom_text = @enterprise.custom_text rescue CustomText.new
    @email = @user.email_for_notification

    set_defaults(@enterprise, method_name)

    mail(from: @from_address, to: @email, subject: @subject) if @email == 'tech@diverst.com' || !Rails.env.development?
  end

  def variables
    {
      user: @user,
      survey: @poll,
      enterprise: @enterprise,
      custom_text: @custom_text,
      click_here: "<a saml_for_enterprise=\"#{@enterprise.id}\" href=\"#{url}\" target=\"_blank\">Click here</a>",
    }
  end

  def url
    ReactRoutes.user.home
  end
end
