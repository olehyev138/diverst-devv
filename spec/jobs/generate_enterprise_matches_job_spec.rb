require 'rails_helper'

RSpec.describe GenerateEnterpriseMatchesJob, type: :job do
  include ActiveJob::TestHelper
  
  describe "#perform" do
    it "calls update_match_scores" do
      user = create(:user)
      expect_any_instance_of(User).to receive(:update_match_scores)

      subject.perform(user.enterprise)
    end
  end
end
