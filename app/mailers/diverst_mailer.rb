class DiverstMailer < Devise::Mailer
 include MailHelper

 def invite(user, token)
   @user = user
   @token = token
   return if @record.enterprise.disable_emails?

   set_defaults(record.enterprise, method_name)

   mail(to: @email, subject: @subject)
 end

 # def reset_password_instructions(record, token, opts = {})
 #   return if record.enterprise.disable_emails?
 #
 #   set_defaults(record.enterprise, method_name)
 #   super
 # end
 #
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
     enterprise: @user.enterprise,
     custom_text: @user.enterprise.custom_text,
     click_here: "<a href=\"#{url}\" target=\"_blank\">TEMP</a>",
   }
 end

 def url
   ReactRoutes.user.home
 end
end
