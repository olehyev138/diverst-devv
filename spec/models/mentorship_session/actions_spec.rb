require 'rails_helper'

RSpec.describe MentorshipSession::Actions, type: :model do
  describe 'valid_includes' do
    it { expect(MentorshipSession.valid_includes.include?('user')).to eq true }
    it { expect(MentorshipSession.valid_includes.include?('mentoring_session')).to eq true }
  end

  describe 'valid_scopes' do
    it { expect(MentorshipSession.valid_scopes.include?('past')).to eq true }
    it { expect(MentorshipSession.valid_scopes.include?('upcoming')).to eq true }
    it { expect(MentorshipSession.valid_scopes.include?('ongoing')).to eq true }
  end

  describe 'base_preloads' do
    it { expect(MentorshipSession.base_preloads.include?(:user)).to eq true }
    it { expect(MentorshipSession.base_preloads.include?(:mentoring_session)).to eq true }
  end

  describe 'accept' do
    let!(:user) { create(:user) }
    let!(:mentoring_session) { create(:mentoring_session) }
    let!(:mentorship_session) { create(:mentorship_session, user: user, mentoring_session: mentoring_session) }

    it 'invalid input' do
      mentorship_session_invalidate = create(:mentorship_session_skips_validate, user: user, mentoring_session: mentoring_session)
      expect { mentorship_session_invalidate.accept! }.to raise_error(InvalidInputException)
    end

    it 'accepted' do
      mentorship_session.accept!
      expect(mentorship_session.status).to eq 'accepted'
    end
  end

  describe 'decline' do
    let!(:user) { create(:user) }
    let!(:mentoring_session) { create(:mentoring_session) }
    let!(:mentorship_session) { create(:mentorship_session, user: user, mentoring_session: mentoring_session) }

    it 'invalid input' do
      mentorship_session_invalidate = create(:mentorship_session_skips_validate, user: user, mentoring_session: mentoring_session)
      expect { mentorship_session_invalidate.decline! }.to raise_error(InvalidInputException)
    end

    it 'declined' do
      mentorship_session.decline!
      expect(mentorship_session.status).to eq 'declined'
    end
  end
end
