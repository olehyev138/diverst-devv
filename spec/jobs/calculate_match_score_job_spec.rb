require 'rails_helper'

RSpec.describe CalculateMatchScoreJob, type: :job do

  describe "#perform" do
    it "skips the existing match" do
      user1 = create(:user)
      user2 = create(:user)
      topic = create(:topic, :user_id => user1.id, :enterprise => user1.enterprise)

      create(:match, :user1 => user1, :user2 => user2, :topic => topic)

      allow(Rails.logger).to receive(:info)

      CalculateMatchScoreJob.new.perform(user1, user2, skip_existing: true)

      expect(Rails.logger).to have_received(:info).with("Skipping existing match")
    end

    it "updates the existing match" do
      user1 = create(:user)
      user2 = create(:user)
      topic = create(:topic, :user_id => user1.id, :enterprise => user1.enterprise)

      create(:match, :user1 => user1, :user2 => user2, :topic => topic)

      allow(Rails.logger).to receive(:info)

      CalculateMatchScoreJob.new.perform(user1, user2)

      expect(Rails.logger).to have_received(:info).with("Updating existing match between users #{user1.id} and #{user2.id}")
    end

    it "creates the match" do
      user1 = create(:user)
      user2 = create(:user)

      allow(Rails.logger).to receive(:info)

      CalculateMatchScoreJob.new.perform(user1, user2)

      expect(Rails.logger).to have_received(:info).with("Creating new match between users #{user1.id} and #{user2.id}")
    end
  end
end