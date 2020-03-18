require 'rails_helper'

RSpec.describe MentoringSession, type: :model do
  describe 'test associations and validations' do
    let(:mentoring_session) { build_stubbed(:mentoring_session) }

    it { expect(mentoring_session).to validate_presence_of(:start) }
    it { expect(mentoring_session).to validate_presence_of(:end) }
    it { expect(mentoring_session).to validate_presence_of(:status) }
    it { expect(mentoring_session).to validate_presence_of(:medium) }

    it { expect(mentoring_session).to have_many(:resources).dependent(:destroy) }
    it { expect(mentoring_session).to have_many(:mentoring_session_topics).dependent(:destroy) }
    it { expect(mentoring_session).to have_many(:mentoring_interests).through(:mentoring_session_topics) }
    it { expect(mentoring_session).to have_many(:mentorship_sessions) }
    it { expect(mentoring_session).to have_many(:users).through(:mentorship_sessions) }
    it { expect(mentoring_session).to have_many(:mentorship_ratings).dependent(:destroy) }
    it { expect(mentoring_session).to have_many(:mentoring_session_comments).dependent(:destroy) }


    it { expect(mentoring_session).to accept_nested_attributes_for(:mentorship_sessions).allow_destroy(true) }
    it { expect(mentoring_session).to accept_nested_attributes_for(:resources).allow_destroy(true) }

    it { expect(mentoring_session).to validate_length_of(:notes).is_at_most(65535) }
    it { expect(mentoring_session).to validate_length_of(:status).is_at_most(191) }
    it { expect(mentoring_session).to validate_length_of(:video_room_name).is_at_most(191) }
    it { expect(mentoring_session).to validate_length_of(:access_token).is_at_most(65535) }
    it { expect(mentoring_session).to validate_length_of(:link).is_at_most(191) }
    it { expect(mentoring_session).to validate_length_of(:medium).is_at_most(191) }
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

  describe '#old_session?' do
    it 'returns false' do
      mentoring_session = create(:mentoring_session, start: Date.current >> 1, end: Date.current >> 2)
      expect(mentoring_session.old_session?).to eq(false)
    end
  end

  describe '#set_room_name' do
    it 'returns video_room_name' do
      mentoring_session = create(:mentoring_session)
      room_name = mentoring_session.set_room_name
      expect(mentoring_session.video_room_name).to eq(room_name)
    end
  end

  describe '#can_start' do
    it 'returns false' do
      mentoring_session = create(:mentoring_session, access_token: 'some access token')
      expect(mentoring_session.can_start(mentoring_session.creator)).to eq(false)
    end
  end

  describe 'notify_users_on_update' do
    # TODO - broken callbacks
    xit 'it calls the mailer method session_updated' do
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
