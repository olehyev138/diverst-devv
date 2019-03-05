require 'rails_helper'

RSpec.describe MentoringSession, :type => :model do

    describe 'validations' do
        let(:mentoring_session) { build_stubbed(:mentoring_session) }

        it{ expect(mentoring_session).to validate_presence_of(:start) }
        it{ expect(mentoring_session).to validate_presence_of(:end) }
        it{ expect(mentoring_session).to validate_presence_of(:status) }
    end
    
    describe 'notify_users_on_update' do
        it "it calls the mailer method session_updated" do
            allow(MentorMailer).to receive(:session_updated).and_call_original
            
            mentoring_session = create(:mentoring_session)
            create(:mentorship_session, :user => create(:user), :mentoring_session => mentoring_session)

            mentoring_session.reload
            
            mentoring_session.start = Date.tomorrow + 3.days
            mentoring_session.end = Date.tomorrow + 4.days
            mentoring_session.save!
            
            expect(MentorMailer).to have_received(:session_updated)
        end
    end
    
    describe 'notify_users_on_destroy' do
        it "it calls the mailer method session_canceled" do
            allow(MentorMailer).to receive(:session_canceled).and_call_original
            
            mentoring_session = create(:mentoring_session)
            create(:mentorship_session, :user => create(:user), :mentoring_session => mentoring_session)

            mentoring_session.reload
            mentoring_session.destroy
            
            expect(MentorMailer).to have_received(:session_canceled)
        end
    end
end