require 'rails_helper'

RSpec.describe SaveUserDataSamplesJob, type: :job do
  include ActiveJob::TestHelper
  
  describe "#perform" do
    it "updates and creates the samples" do
      user_1 = create(:user)  
      user_2 = create(:user)  
      sample = create(:sample, :user_id => user_1.id, :data => user_1.data)
      allow(sample).to receive(:update)
      
      subject.perform
      
      expect(user_2.samples.count).to eq(1)
    end
  end
end
