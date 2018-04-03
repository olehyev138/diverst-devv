require 'rails_helper'

RSpec.describe Mentorship, :type => :model do

    describe 'validations' do
        let(:mentorship) { FactoryGirl.build_stubbed(:mentorship) }

        it{ expect(mentorship).to validate_presence_of(:user) }
        it{ expect(mentorship).to validate_presence_of(:description) }

        it { expect(mentorship).to belong_to(:user) }
    end
    
    describe "mentorship" do
        it "goes through whole workflow" do
            # create mentorship account
            mentee = create(:mentorship)
            
            # it belongs to user and has a description
            expect(mentee.user).to_not be(nil)
            expect(mentee.description).to_not be(nil)
            
            # the mentorship doesn't have any mentors/mentees/availability/
            # mentorship_types/mentoring_interests
            expect(mentee.mentors.count).to eq(0)
            expect(mentee.mentees.count).to eq(0)
            expect(mentee.availabilities.count).to eq(0)
            expect(mentee.mentorship_types.count).to eq(0)
            expect(mentee.mentoring_interests.count).to eq(0)
            
            # the mentorship doesn't have any pending sessions/requests/ratings
            expect(mentee.mentorship_requests.count).to eq(0)
            expect(mentee.mentorship_proposals.count).to eq(0)
            expect(mentee.mentoring_sessions.count).to eq(0)
            expect(mentee.mentorship_ratings.count).to eq(0)
            
            # sending a request for mentorship to a mentor
            mentor = create(:mentorship, :mentor => true)
            mentorship_request = create(:mentoring_request, :sender => mentee, :receiver => mentor)
            
            # check the request
            expect(mentorship_request.valid?).to be(true)
            expect(mentorship_request.sender.id).to eq(mentee.id)
            expect(mentorship_request.receiver.id).to eq(mentor.id)
            
            expect(mentee.mentorship_requests.count).to eq(1)
            expect(mentee.mentorship_proposals.count).to eq(0)
            
            expect(mentor.mentorship_requests.count).to eq(0)
            expect(mentor.mentorship_proposals.count).to eq(1)
            
            # schedule a session
            mentoring_session = create(:mentoring_session, :mentorship_ids => [mentor.id, mentee.id])
            
            # check the session
            expect(mentoring_session.valid?).to be(true)
            expect(mentoring_session.status).to eq("scheduled")
            expect(mentoring_session.mentorships.count).to eq(2)
            
            # leave some ratings
            mentor_rating = build(:mentorship_rating, :mentorship => mentor, :mentoring_session => mentoring_session)
            mentee_rating = build(:mentorship_rating, :mentorship => mentee, :mentoring_session => mentoring_session)
            
            mentor_rating.comments = "This is the best mentor ever"
            mentee_rating.comments = "Mentee was a great listener"
            
            mentor_rating.save!
            mentee_rating.save!
            
            expect(mentor_rating.rating).to eq(7)
            expect(mentee_rating.rating).to eq(7)
        end
    end
end