class SuggestedHireMailer < ApplicationMailer
  helper ResourcesHelper

  def suggest_hire(suggested_hire_id)
    @suggested_hire = SuggestedHire.find_by(id: suggested_hire_id)
    attachments[@suggested_hire.resume_file_name] = File.read(@suggested_hire.resume.path)
    @content = @suggested_hire.message_to_manager
    @candidate_email = @suggested_hire.candidate_email
    @candidate_name = @suggested_hire.candidate_name
    @group = @suggested_hire.group
    @enterprise = @group.enterprise
    return if @enterprise.disable_emails?

    @custom_text = @enterprise.custom_text rescue CustomText.new
    @email = @suggested_hire.manager_email

    set_defaults(@enterprise, method_name)

    mail(from: @from_address, to: @email, subject: 'Suggest a hire')
  end
end
