require 'rails_helper'

RSpec.describe MentoringSession::Actions, type: :model do
  describe 'valid_scopes' do
    it { expect(MentoringSession.valid_scopes.include?('past')).to eq true }
    it { expect(MentoringSession.valid_scopes.include?('upcoming')).to eq true }
    it { expect(MentoringSession.valid_scopes.include?('ongoing')).to eq true }
  end

  describe 'base_preloads' do
    it { expect(MentoringSession.base_preloads.include?(:creator)).to eq true }
    it { expect(MentoringSession.base_preloads.include?(:users)).to eq true }
    it { expect(MentoringSession.base_preloads.include?(:mentoring_interests)).to eq true }
  end
end
