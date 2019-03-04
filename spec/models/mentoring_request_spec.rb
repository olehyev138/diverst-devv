require 'rails_helper'

RSpec.describe MentoringRequest, :type => :model do

    describe 'validations' do
        let(:mentoring_request) { build_stubbed(:mentoring_request) }

        it{ expect(mentoring_request).to validate_presence_of(:sender) }
        it{ expect(mentoring_request).to validate_presence_of(:receiver) }
    end
    
    describe 'notify_declined_request' do
        it "it calls the mailer method notify_declined_request" do
            allow(MentorMailer).to receive(:notify_declined_request).and_call_original
            
            mentoring_request = create(:mentoring_request)
            mentoring_request.notify_declined_request
            
            expect(MentorMailer).to have_received(:notify_declined_request)
        end
    end
    
    describe 'notify_accepted_request' do
        it "it calls the mailer method notify_accepted_request" do
            allow(MentorMailer).to receive(:notify_accepted_request).and_call_original
            
            mentoring_request = create(:mentoring_request)
            mentoring_request.notify_accepted_request
            
            expect(MentorMailer).to have_received(:notify_accepted_request)
        end
    end
end