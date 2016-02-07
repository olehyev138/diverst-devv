require 'rails_helper'

RSpec.describe CacheParticipationScoresJob, type: :job do
  let!(:user) { create(:user) }
  let!(:group) { create(:group) }

  before do
    allow_any_instance_of(User).to receive(:participation_score).and_return(10)
    allow_any_instance_of(Group).to receive(:participation_score).and_return(10)
  end

  it 'updates user scores' do
    Sidekiq::Testing.inline! do
      worker = CacheParticipationScoresJob.new
      worker.perform
      expect(User.first.participation_score_7days).to eq 10
    end
  end

  it 'updates group scores' do
    Sidekiq::Testing.inline! do
      worker = CacheParticipationScoresJob.new
      worker.perform
      expect(Group.first.participation_score_7days).to eq 10
    end
  end
end
