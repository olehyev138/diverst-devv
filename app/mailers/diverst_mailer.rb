#class DiverstMailer < Devise::Mailer
#  include MailHelper
#
#  def invitation_instructions(record, token, opts = {})
#    @record = record
#    @token = token
#    return if @record.enterprise.disable_emails?
#
#    set_defaults(record.enterprise, method_name)
#    super
#  end
#
#  def reset_password_instructions(record, token, opts = {})
#    return if record.enterprise.disable_emails?
#
#    set_defaults(record.enterprise, method_name)
#    super
#  end
#
#  def headers_for(action, opts)
#    headers = {
#      subject: @subject || subject_for(action),
#      to: @email || resource.email_for_notification,
#      from: @from_address, # TODO: devise
#      reply_to: @from_address, # TODO: devise
#      template_path: template_paths,
#      template_name: action
#    }.merge(opts)
#
#    @email = headers[:to]
#    headers
#  end
#
#  def variables
#    {
#      user: @record,
#      enterprise: @record.enterprise,
#      custom_text: @record.enterprise.custom_text,
#      click_here: "<a saml_for_enterprise=\"#{@record.enterprise_id}\" href=\"#{accept_user_invitation_url(@record, invitation_token: @token)}\" target=\"_blank\">Click here</a>",
#    }
#  end
#end
