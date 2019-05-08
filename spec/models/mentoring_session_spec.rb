require 'rails_helper'

RSpec.describe MentoringSession, type: :model do
  describe 'validations' do
    let(:mentoring_session) { build_stubbed(:mentoring_session) }

    it { expect(mentoring_session).to validate_presence_of(:start) }
    it { expect(mentoring_session).to validate_presence_of(:end) }
    it { expect(mentoring_session).to validate_presence_of(:status) }
  end

  describe 'elasticsearch methods' do
    context '#as_indexed_json' do
      let!(:object) { create(:mentoring_session) }

      it 'serializes the correct fields with the correct data' do
        hash = {
          'created_at' => object.created_at.beginning_of_hour,
          'creator' => {
            'first_name' => object.creator.first_name,
            'last_name' => object.creator.last_name,
            'enterprise_id' => object.creator.enterprise_id,
            'active' => object.creator.active
          }
        }
        expect(object.as_indexed_json).to eq(hash)
      end
    end
  end

  describe 'notify_users_on_update' do
    it 'it calls the mailer method session_updated' do
      allow(MentorMailer).to receive(:session_updated).and_call_original

      mentoring_session = create(:mentoring_session)
      create(:mentorship_session, user: create(:user), mentoring_session: mentoring_session)

      mentoring_session.reload

      mentoring_session.start = Date.tomorrow + 3.days
      mentoring_session.end = Date.tomorrow + 4.days
      mentoring_session.save!

      expect(MentorMailer).to have_received(:session_updated)
    end
  end

  describe 'notify_users_on_destroy' do
    it 'it calls the mailer method session_canceled' do
      allow(MentorMailer).to receive(:session_canceled).and_call_original

      mentoring_session = create(:mentoring_session)
      create(:mentorship_session, user: create(:user), mentoring_session: mentoring_session)

      mentoring_session.reload
      mentoring_session.destroy

      expect(MentorMailer).to have_received(:session_canceled)
    end
  end
end
