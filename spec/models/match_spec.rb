require 'rails_helper'

RSpec.describe Match, type: :model do
  describe "when validating" do
    let(:match){ build_stubbed(:match) }
    
    it{ expect(match).to belong_to(:user1) }
    it{ expect(match).to belong_to(:user2) }
    it{ expect(match).to belong_to(:topic) }
  end
    
  describe "update_score" do
    it "updates the score" do
      user1 = create(:user)
      user2 = create(:user)
      topic = create(:topic, :user_id => user1.id, :enterprise => user1.enterprise)
      
      match = create(:match, :user1 => user1, :user2 => user2, :topic => topic)
      match.update_score
      
      expect(match.score).to eq(0.0)
    end
  end
    
  describe "set_status" do
    it "sets the status for user1 to 0" do
      user1 = create(:user)
      user2 = create(:user)
      topic = create(:topic, :user_id => user1.id, :enterprise => user1.enterprise)
      
      match = create(:match, :user1 => user1, :user2 => user2, :topic => topic)
      match.set_status(user: user1, status: "accepted")
      
      expect(match.user1_status).to eq(0)
    end
  end
  
  describe "set_rating" do
    it "sets the rating for user1 to 0" do
      user1 = create(:user)
      user2 = create(:user)
      topic = create(:topic, :user_id => user1.id, :enterprise => user1.enterprise)
      
      match = create(:match, :user1 => user1, :user2 => user2, :topic => topic)
      match.set_rating(user: user1, rating: 0)
      
      expect(match.user1_rating).to eq(0)
    end
    
    it "sets the rating for user2 to 1" do
      user1 = create(:user)
      user2 = create(:user)
      topic = create(:topic, :user_id => user1.id, :enterprise => user1.enterprise)
      
      match = create(:match, :user1 => user1, :user2 => user2, :topic => topic)
      match.set_rating(user: user2, rating: 1)
      
      expect(match.user2_rating).to eq(1)
    end
    
    it "raises error" do
      user1 = create(:user)
      user2 = create(:user)
      user3 = create(:user)
      topic = create(:topic, :user_id => user1.id, :enterprise => user1.enterprise)
      
      match = create(:match, :user1 => user1, :user2 => user2, :topic => topic)
      
      
      expect{match.set_rating(user: user3, rating: 1)}.to raise_error Exception, "User not part of match"
    end
  end
  
  describe "status_for" do
    it "retrieves the status for user1" do
      user1 = create(:user)
      user2 = create(:user)
      topic = create(:topic, :user_id => user1.id, :enterprise => user1.enterprise)
      
      match = create(:match, :user1 => user1, :user2 => user2, :topic => topic)
      match.status_for(user1)
      
      expect(match.status_for(user1)).to eq(0)
    end
    
    it "retrieves the status for user2" do
      user1 = create(:user)
      user2 = create(:user)
      topic = create(:topic, :user_id => user1.id, :enterprise => user1.enterprise)
      
      match = create(:match, :user1 => user1, :user2 => user2, :topic => topic)
      
      expect(match.status_for(user2)).to eq(0)
    end
    
    it "raises error" do
      user1 = create(:user)
      user2 = create(:user)
      user3 = create(:user)
      topic = create(:topic, :user_id => user1.id, :enterprise => user1.enterprise)
      
      match = create(:match, :user1 => user1, :user2 => user2, :topic => topic)
      expect{match.status_for(user3)}.to raise_error Exception, "User not part of match"
    end
  end
  
  describe "rating_for" do
    it "retrieves the rating for user1" do
      user1 = create(:user)
      user2 = create(:user)
      topic = create(:topic, :user_id => user1.id, :enterprise => user1.enterprise)
      
      match = create(:match, :user1 => user1, :user2 => user2, :topic => topic)
      match.set_rating(user: user1, rating: 0)
      
      expect(match.rating_for(user1)).to eq(0)
    end
    
    it "retrieves the rating for user2" do
      user1 = create(:user)
      user2 = create(:user)
      topic = create(:topic, :user_id => user1.id, :enterprise => user1.enterprise)
      
      match = create(:match, :user1 => user1, :user2 => user2, :topic => topic)
      match.set_rating(user: user2, rating: 1)
      
      expect(match.rating_for(user2)).to eq(1)
    end
    
    it "raises error" do
      user1 = create(:user)
      user2 = create(:user)
      user3 = create(:user)
      topic = create(:topic, :user_id => user1.id, :enterprise => user1.enterprise)
      
      match = create(:match, :user1 => user1, :user2 => user2, :topic => topic)
      expect{match.rating_for(user3)}.to raise_error Exception, "User not part of match"
    end
  end
  
  describe "other" do
    it "retrieves user2" do
      user1 = create(:user)
      user2 = create(:user)
      topic = create(:topic, :user_id => user1.id, :enterprise => user1.enterprise)
      
      match = create(:match, :user1 => user1, :user2 => user2, :topic => topic)
  
      expect(match.other(user1)).to be(user2)
    end
    
    it "retrieves user1" do
      user1 = create(:user)
      user2 = create(:user)
      topic = create(:topic, :user_id => user1.id, :enterprise => user1.enterprise)
      
      match = create(:match, :user1 => user1, :user2 => user2, :topic => topic)

      expect(match.other(user2)).to be(user1)
    end
    
    it "raises error" do
      user1 = create(:user)
      user2 = create(:user)
      user3 = create(:user)
      topic = create(:topic, :user_id => user1.id, :enterprise => user1.enterprise)
      
      match = create(:match, :user1 => user1, :user2 => user2, :topic => topic)
      expect{match.other(user3)}.to raise_error Exception, "User not part of match"
    end
  end
  
  describe "both_accepted?" do
    it "returns true" do
      user1 = create(:user)
      user2 = create(:user)
      topic = create(:topic, :user_id => user1.id, :enterprise => user1.enterprise)
      
      match = create(:match, :user1 => user1, :user2 => user2, :topic => topic, :user1_status => 1, :user2_status => 1)
  
      expect(match.both_accepted?).to eq(true)
    end
    
    it "returns false" do
      user1 = create(:user)
      user2 = create(:user)
      topic = create(:topic, :user_id => user1.id, :enterprise => user1.enterprise)
      
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
end
