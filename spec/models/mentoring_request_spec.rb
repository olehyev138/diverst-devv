require 'rails_helper'

RSpec.describe MentoringRequest, :type => :model do

    describe 'validations' do
        let(:mentoring_request) { build_stubbed(:mentoring_request) }

        it{ expect(mentoring_request).to validate_presence_of(:sender) }
        it{ expect(mentoring_request).to validate_presence_of(:receiver) }

        context "custom validations" do
          let(:sender) { create(:user) }
          let(:receiver) { create(:user, accepting_mentor_requests: false) }
          let(:receiver2) { create(:user, accepting_mentee_requests: false) }

          it 'fails to create when receiver is not accepting mentor requests' do
            mentoring_request = build(:mentoring_request, sender: sender, receiver: receiver, mentoring_type: "mentor")

            expect(mentoring_request.valid?).to eq false
            expect(mentoring_request.errors[:receiver]).to include('is not currently accepting mentor requests')
          end

          it 'fails to create when receiver is not accepting mentee requests' do
            mentoring_request = build(:mentoring_request, sender: sender, receiver: receiver2, mentoring_type: "mentee")

            expect(mentoring_request.valid?).to eq false
            expect(mentoring_request.errors[:receiver]).to include('is not currently accepting mentee requests')
          end
        end
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