require 'rails_helper'

RSpec.describe UsersDownloadJob, type: :job do
    include ActiveJob::TestHelper
    
    describe "#perform" do
        it "sends an email" do
            allow(UsersDownloadMailer).to receive(:send_csv).and_call_original
            
            enterprise = create(:enterprise)
            user = create(:user, :enterprise => enterprise)
            
            subject.perform(user.id)
            
            expect(UsersDownloadMailer).to have_received(:send_csv)
        end
    end
end