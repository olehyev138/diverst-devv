require 'rails_helper'

RSpec.describe MentoringSession::Actions, type: :model do
  describe 'valid_scopes' do
    let(:valid_scopes) {
      %w(
          past
          upcoming
          ongoing
      )
    }

    it { expect(MentoringSession.valid_scopes).to eq valid_scopes }
  end

  describe 'base_preloads' do
    let!(:base_preloads) {
      [
          :creator,
          :users,
          :mentoring_interests,
          creator: [
              :mentoring_interests,
              :mentoring_types,
              :mentors,
              :mentees,
              :mentorship_ratings,
              :availabilities,
              mentees: [
                  :mentoring_interests,
                  :mentoring_types,
                  :availabilities
              ],
              mentors: [
                  :mentoring_interests,
                  :mentoring_types,
                  :availabilities
              ]
          ],
          users: [
              :mentoring_interests,
              :mentoring_types,
              :availabilities
          ]
      ]
    }

    it { expect(MentoringSession.base_preloads(Request.create_request(nil))).to eq base_preloads }
  end
end
