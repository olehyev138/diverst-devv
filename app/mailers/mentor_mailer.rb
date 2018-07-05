class MentorMailer < ApplicationMailer
    
    # sends an email to the mentoring request receiver to let them know
    # that someone has requested mentoring
    
    def new_mentoring_request(mentoring_request)
        @mentoring_request = mentoring_request
        @sender = mentoring_request.sender
        @receiver = mentoring_request.receiver
        
        mail(to: @receiver.email, subject: "New Mentoring Request")
    end
    
    # sends a reminder email to users regarding an upcoming session
    
    def session_reminder(user_id, mentoring_session_id)
        @mentoring_session = MentoringSession.find(mentoring_session_id)
        @user = User.find(user_id)
        
        mail(to: @user.email, subject: "Reminder: Mentoring Session Scheduled for #{@mentoring_session.start.strftime("%m/%d/%Y %I:%M %p")}")
    end
end