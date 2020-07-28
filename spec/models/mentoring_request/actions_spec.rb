require 'rails_helper'

RSpec.describe MentoringRequest::Actions, type: :model do
  describe 'valid_includes' do
    it { expect(MentoringRequest.valid_includes.include?('sender')).to eq true }
    it { expect(MentoringRequest.valid_includes.include?('receiver')).to eq true }
  end

  describe 'valid_scopes' do
    it { expect(MentoringRequest.valid_scopes.include?('pending')).to eq true }
    it { expect(MentoringRequest.valid_scopes.include?('accepted')).to eq true }
    it { expect(MentoringRequest.valid_scopes.include?('rejected')).to eq true }
  end

  describe 'accept' do
    it 'raises an exception if request is invalid' do
      sender = create(:user)
      receiver = create(:user)
      create(:mentoring_request, sender: sender, receiver: receiver)
      invalid_mentoring_request = create(:mentoring_request_skips_validate, sender: sender, receiver: receiver)
      expect { invalid_mentoring_request.accept(Request.create_request(create(:user))) }.to raise_error(InvalidInputException)
    end

    it 'accepts if mentoring type is mentor' do
      mentoring_request_mentor = create(:mentoring_request, mentoring_type: 'mentor')
      mentoring_request_mentor.accept(Request.create_request(create(:user)))

      expect(Mentoring.first.mentor_id).to eq mentoring_request_mentor.receiver_id
      expect(Mentoring.first.mentee_id).to eq mentoring_request_mentor.sender_id

      ActiveJob::Base.queue_adapter = :test
      expect {
        MentorMailer.notify_accepted_request(mentoring_request_mentor.receiver_id, mentoring_request_mentor.sender_id).deliver_later
      }.to have_enqueued_job.on_queue('mailers')
    end

    it 'accepts if mentoring type is mentee' do
      mentoring_request_mentee = create(:mentoring_request, mentoring_type: 'mentee')
      mentoring_request_mentee.accept(Request.create_request(create(:user)))

      expect(Mentoring.first.mentor_id).to eq mentoring_request_mentee.sender_id
      expect(Mentoring.first.mentee_id).to eq mentoring_request_mentee.receiver_id

      ActiveJob::Base.queue_adapter = :test
      expect {
        MentorMailer.notify_accepted_request(mentoring_request_mentee.receiver_id, mentoring_request_mentee.sender_id).deliver_later
      }.to have_enqueued_job.on_queue('mailers')
    end
  end

  describe 'reject' do
    it 'raises an exception if request is invalid' do
      sender = create(:user)
      receiver = create(:user)
      create(:mentoring_request, sender: sender, receiver: receiver)
      invalid_mentoring_request = create(:mentoring_request_skips_validate, sender: sender, receiver: receiver)
      expect { invalid_mentoring_request.reject }.to raise_error(InvalidInputException)
    end

    it 'rejects' do
      mentoring_request_mentor = create(:mentoring_request)
      mentoring_request_mentor.reject

      ActiveJob::Base.queue_adapter = :test
      expect {
        MentorMailer.notify_declined_request(mentoring_request_mentor.receiver_id, mentoring_request_mentor.sender_id).deliver_later
      }.to have_enqueued_job.on_queue('mailers')
    end
  end
end
