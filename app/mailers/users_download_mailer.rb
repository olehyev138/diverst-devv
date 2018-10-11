class UsersDownloadMailer < ApplicationMailer
    
    # sends an email to the mentoring request receiver to let them know
    # that someone has requested mentoring
    
    def send_csv(email, csv_file, filename = "diverst_users.csv")
        attachments[filename] = {mime_type: 'text/csv', content: csv_file}
        mail(from: "info@diverst.com", to: email, subject: "Diverst User Export Download")
    end
end