require 'rails_helper'

RSpec.describe Match, type: :model do
  describe "when validating" do
    let(:match){ build_stubbed(:match) }

    it{ expect(match).to belong_to(:user1).class_name('User') }
    it{ expect(match).to belong_to(:user2).class_name('User') }
    it{ expect(match).to belong_to(:topic) }
    it{ expect(match).to accept_nested_attributes_for(:user1).allow_destroy(true) }
    it{ expect(match).to accept_nested_attributes_for(:user2).allow_destroy(true) }
  end

  describe "update_score" do
    it "updates the score" do
      user1 = build(:user)
      user2 = build(:user)
      topic = build(:topic, :user_id => user1.id, :enterprise => user1.enterprise)

      match = create(:match, :user1 => user1, :user2 => user2, :topic => topic)
      match.update_score

      expect(match.score).to eq(0.0)
    end
  end

  describe "set_status" do
    it "sets the status for user1 to 0" do
      user1 = build(:user)
      user2 = build(:user)
      topic = build(:topic, :user_id => user1.id, :enterprise => user1.enterprise)

      match = create(:match, :user1 => user1, :user2 => user2, :topic => topic)
      match.set_status(user: user1, status: "accepted")

      expect(match.user1_status).to eq(0)
    end

    it "sets the status for user2 to 0" do
      user1 = build(:user)
      user2 = build(:user)
      topic = build(:topic, :user_id => user1.id, :enterprise => user1.enterprise)

      match = create(:match, :user1 => user1, :user2 => user2, :topic => topic)
      match.set_status(user: user2, status: "accepted")

      expect(match.user2_status).to eq(0)
    end

    it "fails" do
      user1 = build(:user)
      user2 = build(:user)
      user3 = build(:user)
      topic = build(:topic, :user_id => user1.id, :enterprise => user1.enterprise)

      match = create(:match, :user1 => user1, :user2 => user2, :topic => topic)
      expect{match.set_status(user: user3, status: "accepted")}.to raise_error Exception
    end
  end

  describe "set_rating" do
    it "sets the rating for user1 to 0" do
      user1 = build(:user)
      user2 = build(:user)
      topic = build(:topic, :user_id => user1.id, :enterprise => user1.enterprise)

      match = create(:match, :user1 => user1, :user2 => user2, :topic => topic)
      match.set_rating(user: user1, rating: 0)

      expect(match.user1_rating).to eq(0)
    end

    it "sets the rating for user2 to 1" do
      user1 = build(:user)
      user2 = build(:user)
      topic = build(:topic, :user_id => user1.id, :enterprise => user1.enterprise)

      match = create(:match, :user1 => user1, :user2 => user2, :topic => topic)
      match.set_rating(user: user2, rating: 1)

      expect(match.user2_rating).to eq(1)
    end

    it "raises error" do
      user1 = build(:user)
      user2 = build(:user)
      user3 = build(:user)
      topic = build(:topic, :user_id => user1.id, :enterprise => user1.enterprise)

      match = create(:match, :user1 => user1, :user2 => user2, :topic => topic)


      expect{match.set_rating(user: user3, rating: 1)}.to raise_error Exception, "User not part of match"
    end
  end

  describe "status_for" do
    it "retrieves the status for user1" do
      user1 = build(:user)
      user2 = build(:user)
      topic = build(:topic, :user_id => user1.id, :enterprise => user1.enterprise)

      match = create(:match, :user1 => user1, :user2 => user2, :topic => topic)
      match.status_for(user1)

      expect(match.status_for(user1)).to eq(0)
    end

    it "retrieves the status for user2" do
      user1 = build(:user)
      user2 = build(:user)
      topic = build(:topic, :user_id => user1.id, :enterprise => user1.enterprise)

      match = create(:match, :user1 => user1, :user2 => user2, :topic => topic)

      expect(match.status_for(user2)).to eq(0)
    end

    it "raises error" do
      user1 = build(:user)
      user2 = build(:user)
      user3 = build(:user)
      topic = build(:topic, :user_id => user1.id, :enterprise => user1.enterprise)

      match = create(:match, :user1 => user1, :user2 => user2, :topic => topic)
      expect{match.status_for(user3)}.to raise_error Exception, "User not part of match"
    end
  end

  describe "rating_for" do
    it "retrieves the rating for user1" do
      user1 = build(:user)
      user2 = build(:user)
      topic = build(:topic, :user_id => user1.id, :enterprise => user1.enterprise)

      match = create(:match, :user1 => user1, :user2 => user2, :topic => topic)
      match.set_rating(user: user1, rating: 0)

      expect(match.rating_for(user1)).to eq(0)
    end

    it "retrieves the rating for user2" do
      user1 = build(:user)
      user2 = build(:user)
      topic = build(:topic, :user_id => user1.id, :enterprise => user1.enterprise)

      match = create(:match, :user1 => user1, :user2 => user2, :topic => topic)
      match.set_rating(user: user2, rating: 1)

      expect(match.rating_for(user2)).to eq(1)
    end

    it "raises error" do
      user1 = build(:user)
      user2 = build(:user)
      user3 = build(:user)
      topic = build(:topic, :user_id => user1.id, :enterprise => user1.enterprise)

      match = create(:match, :user1 => user1, :user2 => user2, :topic => topic)
      expect{match.rating_for(user3)}.to raise_error Exception, "User not part of match"
    end
  end

  describe "other" do
    it "retrieves user2" do
      user1 = build(:user)
      user2 = build(:user)
      topic = build(:topic, :user_id => user1.id, :enterprise => user1.enterprise)

      match = create(:match, :user1 => user1, :user2 => user2, :topic => topic)

      expect(match.other(user1)).to be(user2)
    end

    it "retrieves user1" do
      user1 = build(:user)
      user2 = build(:user)
      topic = build(:topic, :user_id => user1.id, :enterprise => user1.enterprise)

      match = create(:match, :user1 => user1, :user2 => user2, :topic => topic)

      expect(match.other(user2)).to be(user1)
    end

    it "raises error" do
      user1 = build(:user)
      user2 = build(:user)
      user3 = build(:user)
      topic = build(:topic, :user_id => user1.id, :enterprise => user1.enterprise)

      match = create(:match, :user1 => user1, :user2 => user2, :topic => topic)
      expect{match.other(user3)}.to raise_error Exception, "User not part of match"
    end
  end

  describe "both_accepted?" do
    it "returns true" do
      user1 = build(:user)
      user2 = build(:user)
      topic = build(:topic, :user_id => user1.id, :enterprise => user1.enterprise)

      match = create(:match, :user1 => user1, :user2 => user2, :topic => topic, :user1_status => 1, :user2_status => 1)

      expect(match.both_accepted?).to eq(true)
    end

    it "returns false" do
      user1 =  build(:user)
      user2 =  build(:user)
      topic =  build(:topic, :user_id => user1.id, :enterprise => user1.enterprise)

      match = create(:match, :user1 => user1, :user2 => user2, :topic => topic, :user1_status => 1, :user2_status => 0)

      expect(match.both_accepted?).to eq(false)
    end
  end

  describe "status" do
    it "returns hash" do
      expect(Match.status).to eq({:unswiped => 0, :accepted => 1, :rejected => 2, :saved => 3, :left => 4})
    end
  end

  describe "expiration_time" do
    it "returns hash" do
      expect(Match.expiration_time).to eq(2.weeks)
    end
  end

  describe "soon_expired" do
    it "returns 1 item" do
      user_1 = build(:user)
      user_2 = build(:user)
      create(:match, :archived => false, :both_accepted_at => 10.days.ago, :user1 => user_1, :user2 => user_2, :user1_status => 1, :user2_status => 1)

      expect(Match.soon_expired.count).to eq(1)
    end
  end

  describe "expired" do
    it "returns 1 item" do
      user_1 = build(:user)
      user_2 = build(:user)
      create(:match, :archived => false, :both_accepted_at => 15.days.ago, :user1 => user_1, :user2 => user_2, :user1_status => 1, :user2_status => 1)

      expect(Match.expired.count).to eq(1)
    end
  end

  describe "both_accepted_notification" do
    it "sends notification to users" do
      allow_any_instance_of(User).to receive(:notify)

      user_1 = build(:user)
      user_2 = build(:user)
      match = create(:match, :archived => false, :both_accepted_at => 15.days.ago, :user1 => user_1, :user2 => user_2, :user1_status => 1, :user2_status => 1)
      match.both_accepted_notification

      expect(user_2).to have_received(:notify).with("You have been matched with #{match.other(user_2).first_name}. Start a conversation now!", type: 'new_match', id: match.id)
    end
  end

  describe "expires_soon_notification" do
    it "sends notification to users" do
      allow_any_instance_of(User).to receive(:notify)

      user_1 = build(:user)
      user_2 = build(:user)
      match = create(:match, :archived => false, :both_accepted_at => 15.days.ago, :user1 => user_1, :user2 => user_2, :user1_status => 1, :user2_status => 1)
      match.expires_soon_notification

      expect(user_2).to have_received(:notify).with("Your conversation with #{match.other(user_2).first_name} will soon expire. Would you like to save him/her?", type: 'match_expires_soon', id: match.id)
    end
  end

  describe "left_notification" do
    it "sends notification to users" do
      allow_any_instance_of(User).to receive(:notify)

      user_1 = build(:user)
      user_2 = build(:user)
      match = create(:match, :archived => false, :both_accepted_at => 15.days.ago, :user1 => user_1, :user2 => user_2, :user1_status => 1, :user2_status => 1)
      match.left_notification

      expect(user_2).to have_received(:notify).with("Bummer! #{match.other(user_2).first_name} has left the conversation. Meet new people in you organisation here!", type: 'match_left', id: match.id)
    end
  end

  describe "conversation_state?" do
    it "returns true" do
      user_1 = build(:user)
      user_2 = build(:user)
      match = create(:match, :archived => false, :both_accepted_at => 15.days.ago, :user1 => user_1, :user2 => user_2, :user1_status => 1, :user2_status => 1)

      expect(match.conversation_state?).to be(true)
    end
  end

  describe "expires_soon_for?" do
    it "returns false" do
      user_1 = build(:user)
      user_2 = build(:user)
      match = create(:match, :archived => false, :both_accepted_at => 15.days.ago, :user1 => user_1, :user2 => user_2, :user1_status => 1, :user2_status => 1)

      expect(match.expires_soon_for?(user: user_1)).to be(false)
    end

    it "returns true" do
      user_1 = build(:user)
      user_2 = build(:user)
      match = create(:match, :archived => false, :both_accepted_at => 10.days.ago, :user1 => user_1, :user2 => user_2, :user1_status => 1, :user2_status => 1)

      expect(match.expires_soon_for?(user: user_1)).to be(true)
    end
  end

  describe "expiration_date" do
    it "returns date" do
      user_1 = build(:user)
      user_2 = build(:user)
      match = create(:match, :archived => false, :both_accepted_at => 15.days.ago, :user1 => user_1, :user2 => user_2, :user1_status => 1, :user2_status => 1)

      expect(match.expiration_date).to eq(match.both_accepted_at + Match.expiration_time)
    end
  end

  describe "saved?" do
    it "returns true" do
      user_1 = build(:user)
      user_2 = build(:user)
      match = create(:match, :user1 => user_1, :user2 => user_2, :user1_status => 3, :user2_status => 3)

      expect(match.saved?).to be(true)
    end
  end
end
