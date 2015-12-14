require 'rails_helper'

RSpec.describe CacheParticipationScoresJob, type: :job do
  let! (:employee) { create(:employee) }
  let! (:group) { create(:group) }

  before do
    allow_any_instance_of(Employee).to receive(:participation_score).and_return(10)
    allow_any_instance_of(Group).to receive(:participation_score).and_return(10)
  end

  it "updates employee scores" do
    Sidekiq::Testing.inline! do
      worker = CacheParticipationScoresJob.new
      worker.perform
      expect(Employee.first.participation_score_7days).to eq 10
    end
  end

  it "updates group scores" do
    Sidekiq::Testing.inline! do
      worker = CacheParticipationScoresJob.new
      worker.perform
      expect(Group.first.participation_score_7days).to eq 10
    end
  end
end
