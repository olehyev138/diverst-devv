require 'rails_helper'

RSpec.describe MentorshipSession, type: :model do
  let(:user) { create(:user) }
  let(:mentorship_session) { create(:mentorship_session) }

  describe 'associations and validations' do
    it { expect(mentorship_session).to belong_to(:user) }
    it { expect(mentorship_session).to belong_to(:mentoring_session) }

    it { expect(mentorship_session).to validate_presence_of(:user) }
    it { expect(mentorship_session).to validate_presence_of(:mentoring_session).on(:update) }
    it { expect(mentorship_session).to validate_uniqueness_of(:user_id).scoped_to(:mentoring_session_id) }
    it { expect(mentorship_session).to validate_length_of(:status).is_at_most(191) }
    it { expect(mentorship_session).to validate_length_of(:role).is_at_most(191) }
  end

  describe 'test scopes' do
    context 'mentorship_session::past' do
      let!(:past_mentorship_session) { create(:mentorship_session, mentoring_session: create(:mentoring_session, start: Time.now - 1 * 60, end: Time.now - 1 * 50)) }

      it 'returns past mentoring session' do
        expect(MentorshipSession.past).to eq([past_mentorship_session])
      end
    end

    context 'mentorship_session::upcoming' do
      let!(:upcoming_mentorship_session) { create(:mentorship_session, mentoring_session: create(:mentoring_session, start: Date.tomorrow)) }

      it 'returns upcoming mentoring session' do
        expect(MentorshipSession.upcoming).to eq([upcoming_mentorship_session])
      end
    end

    context 'mentorship_session::ongoing' do
      let!(:ongoing_mentorship_session) { create(:mentorship_session, mentoring_session: create(:mentoring_session, start: Time.now - 1 * 60, end: Date.tomorrow)) }

      it 'returns ongoing mentoring session' do
        expect(MentorshipSession.ongoing).to eq([ongoing_mentorship_session])
      end
    end
  end

  describe 'methods' do
    context 'setters' do
      it 'sets pending status' do
        mentorship_session.pending
        expect(mentorship_session.status).to eq 'pending'
      end

      it 'sets accepted status' do
        mentorship_session.accept
        expect(mentorship_session.status).to eq 'accepted'
      end

      it 'sets declined status' do
        mentorship_session.decline
        expect(mentorship_session.status).to eq 'declined'
      end
    end

    context 'getters' do
      it 'checks creator' do
        mentorship_session.user = user
        mentorship_session.mentoring_session.creator = user
        expect(mentorship_session.creator?).to eq true
      end

      it 'checks pending status' do
        mentorship_session.status = 'pending'
        expect(mentorship_session.pending?).to eq true
      end

      it 'checks accepted status' do
        mentorship_session.status = 'accepted'
        expect(mentorship_session.accepted?).to eq true
      end

      it 'checks declined status' do
        mentorship_session.status = 'declined'
        expect(mentorship_session.declined?).to eq true
      end
    end
  end
end
