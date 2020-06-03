class PollResponseMailer < ApplicationMailer
  def notification(response_id, user_id)
    @user = User.find_by(id: user_id)
    @response = PollResponse.find_by(id: response_id)
    @enterprise = @user.enterprise
    return if @enterprise.disable_emails?

    @custom_text = @enterprise.custom_text rescue CustomText.new
    @email = @user.email_for_notification

    set_defaults(@enterprise, method_name)

    mail(from: @from_address, to: @email, subject: @subject)
  end

  def variables
    {
      user: @user,
      survey: @response.poll,
      enterprise: @enterprise
    }
  end
end
