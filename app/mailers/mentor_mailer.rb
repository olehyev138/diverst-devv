class MentorMailer < ApplicationMailer
  # sends an email to the mentoring request receiver to let them know
  # that someone has requested mentoring

  def new_mentoring_request(id)
    mentoring_request = MentoringRequest.find_by_id(id)
    return if mentoring_request.nil?

    @mentoring_request = mentoring_request
    @sender = mentoring_request.sender
    @receiver = mentoring_request.receiver
    @email = @receiver.email_for_notification
    return if @sender.enterprise.disable_emails?

    set_defaults(@sender.enterprise, method_name)

    mail(from: @from_address, to: @email, subject: 'New Mentoring Request')
  end

  def session_scheduled(mentoring_session_id, user_id)
    @mentoring_session = MentoringSession.find_by_id(mentoring_session_id)
    return if @mentoring_session.nil?

    @user = User.find_by_id(user_id)
    return if @user.nil?
    return if @user.enterprise.disable_emails?

    @mentorship_session = @mentoring_session.mentorship_sessions.find_by(user_id: @user.id)
    @email = @user.email_for_notification

    set_defaults(@user.enterprise, method_name)

    mail(to: @email, subject: "Mentoring Session Scheduled for #{@mentoring_session.start.in_time_zone(@user.default_time_zone).strftime("%m/%d/%Y %I:%M %p")}")
  end

  def session_updated(user_id, mentoring_session_id)
    @mentoring_session = MentoringSession.find_by_id(mentoring_session_id)
    return if @mentoring_session.nil?

    @user = User.find_by_id(user_id)
    return if @user.nil?
    return if @user.enterprise.disable_emails?

    @email = @user.email_for_notification

    set_defaults(@user.enterprise, method_name)

    mail(to: @email, subject: "Mentoring Session Scheduled for #{@mentoring_session.start.in_time_zone(@user.default_time_zone).strftime("%m/%d/%Y %I:%M %p")} has been updated")
  end

  def session_canceled(start, user_id)
    @start = start

    @user = User.find_by_id(user_id)
    return if @user.nil?

    return if @user.enterprise.disable_emails?

    @email = @user.email_for_notification
    set_defaults(@user.enterprise, method_name)

    mail(to: @email, subject: "Mentoring Session Scheduled for #{@start} has been canceled")
  end

  def session_declined(user_id, mentoring_session_id, declined_user_id)
    @mentoring_session = MentoringSession.find_by_id(mentoring_session_id)
    return if @mentoring_session.nil?

    @user = User.find_by_id(user_id)
    return if @user.nil?
    return if @user.enterprise.disable_emails?

    @declined_user = User.find_by_id(declined_user_id)
    return if @declined_user.nil?

    @email = @user.email_for_notification
    set_defaults(@user.enterprise, method_name)

    mail(to: @email, subject: "#{@declined_user.name} has declined your Mentoring Session")
  end

  def notify_declined_request(receiver_id, sender_id)
    @receiver = User.find_by_id(receiver_id)
    return if @receiver.nil?

    @sender = User.find_by_id(sender_id)
    return if @sender.nil?
    return if @sender.enterprise.disable_emails?

    @email = @sender.email_for_notification
    set_defaults(@sender.enterprise, method_name)

    mail(to: @email, subject: 'Mentor Request Declined')
  end

  def notify_accepted_request(receiver_id, sender_id)
    @receiver = User.find_by_id(receiver_id)
    return if @receiver.nil?

    @sender = User.find_by_id(sender_id)
    return if @sender.nil?
    return if @sender.enterprise.disable_emails?

    @email = @sender.email_for_notification
    set_defaults(@sender.enterprise, method_name)

    mail(to: @email, subject: 'Mentor Request Accepted')
  end

  # sends a reminder email to users regarding an upcoming session

  def session_reminder(user_id, mentoring_session_id)
    @mentoring_session = MentoringSession.find_by_id(mentoring_session_id)
    return if @mentoring_session.nil?

    @user = User.find_by_id(user_id)
    return if @user.nil?
    return if @user.enterprise.disable_emails?

    @email = @user.email_for_notification
    set_defaults(@user.enterprise, method_name)

    mail(to: @email, subject: "Reminder: Mentoring Session Scheduled for #{@mentoring_session.start.in_time_zone(@user.default_time_zone).strftime("%m/%d/%Y %I:%M %p")}")
  end
end
