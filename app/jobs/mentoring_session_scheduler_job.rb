class MentoringSessionSchedulerJob < ActiveJob::Base
  queue_as :default

  # send daily reminders to users who have sessions scheduled for times between tomorrow and the day after tomorrow
  # only sends reminders for sessions with a status of scheduled since some sessions can be cancelled

  def perform
    mentoring_session_ids = MentoringSession.where(start: Date.tomorrow..Date.tomorrow + 1.day, status: 'scheduled').pluck(:id)
    mentoring_session_ids.each do |mentoring_session_id|
      mentoring_session = MentoringSession.find(mentoring_session_id)

      # send an email to the presenter/mentor and mentees/attendees
      mentoring_session.users.ids do |user_id|
        MentorMailer.session_reminder(user_id, mentoring_session_id).deliver_later
      end
    end
  end
end
