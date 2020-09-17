class SuggestedHireMailer < ApplicationMailer
  def suggest_hire(suggested_hire_id)
    @suggested_hire = SuggestedHire.find_by(id: suggested_hire_id)
    @candidate_email = @suggested_hire.candidate_email
    @candidate_name = @suggested_hire.candidate_name
    @group = @suggested_hire.group
    @enterprise = @group.enterprise
    return if @enterprise.disable_emails?

    @custom_text = @enterprise.custom_text rescue CustomText.new
    @email = @suggested_hire.manager_email

    set_defaults(@enterprise, method_name)

    mail(from: @from_address, to: @email, subject: @subject)
  end

  def variables
    {
      candidate_name: @candidate_name,
      resume: @suggested_hire.resume,
      enterprise: @enterprise,
      custom_text: @custom_text,
      click_here: "<a saml_for_enterprise=\"#{@enterprise.id}\" href=\"#{url}\" target=\"_blank\">Click here</a>"
    } 
  end

  def url
    @suggest_hire.resume.expiring_url(3600)
  end
end
