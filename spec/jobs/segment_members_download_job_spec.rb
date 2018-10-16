require 'rails_helper'

RSpec.describe SegmentMembersDownloadJob, type: :job do
    include ActiveJob::TestHelper
    
    describe "#perform" do
        it "sends an email when there's no group" do
            allow(UsersDownloadMailer).to receive(:send_csv).and_call_original
            
            enterprise = create(:enterprise)
            user = create(:user, :enterprise => enterprise)
            segment = create(:segment, :enterprise => enterprise)
            create(:users_segment, :user => user, :segment => segment)
            
            subject.perform(user.id, segment.id)
            
            expect(UsersDownloadMailer).to have_received(:send_csv)
        end
        
        it "sends an email when there's a group" do
            allow(UsersDownloadMailer).to receive(:send_csv).and_call_original
            
            enterprise = create(:enterprise)
            user = create(:user, :enterprise => enterprise)
            group = create(:group, :enterprise => enterprise)
            create(:user_group, :user => user, :group => group)
            segment = create(:segment, :enterprise => enterprise)
            create(:users_segment, :user => user, :segment => segment)
            
            subject.perform(user.id, segment.id, group.id)
            
            expect(UsersDownloadMailer).to have_received(:send_csv)
        end
    end
end