class CustomEmailMailer < ApplicationMailer
    def custom(custom_email, emails)
        return unless custom_email.custom?

        set_defaults(@custom_email.enterprise, 'custom')

        #TODO check emails are unique
        emails.each do |email|
            mail(from: @from_address, to: email, subject: email.subject)
        end
    end
end
